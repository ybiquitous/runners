module Runners
  module Issues
    class InvalidIssueError < StandardError
      # @dynamic issue
      attr_reader :issue

      def initialize(issue:)
        @issue = issue
      end
    end

    class Base
      # @dynamic path, location, id
      attr_reader :path
      attr_reader :location
      attr_reader :id

      # @type method ensure_validity: ?{ (self) -> any } -> any
      def ensure_validity
        raise InvalidIssueError.new(issue: self) unless valid?

        if block_given?
          yield self
        else
          self
        end
      end

      def eql?(other)
        self == other
      end

      def hash
        path.hash ^ location.hash ^ id.hash
      end

      def valid?
        case
        when !path.instance_of?(Pathname)
          false
        when (loc = location) && !loc.valid?
          false
        when !id
          false
        else
          true
        end
      end

      def as_json
        ensure_validity do
          {
            path: path.to_s,
            location: location&.as_json,
            id: id,
          }
        end
      end
    end

    # Issue with id, but no other information.
    # Do we really need this??
    class Identified < Base
      def initialize(path:, location:, id:)
        @path = path
        @location = location
        @id = id
      end

      def ==(other)
        other.class == self.class &&
          other.path == path &&
          other.location == location &&
          other.id == id
      end
    end

    # Issue with structure, will be formatted later, maybe by frontend
    class Structured < Base
      class InvalidObject < StandardError
        # @dynamic object
        attr_reader :object

        def initialize(object:)
          @object = object
        end
      end

      # @dynamic object
      attr_reader :object

      def initialize(path:, location:, id:, object:, schema:)
        @path = path
        @location = location
        @id = id
        @object = object

        ss = Array(schema)
        unless ss.empty? || ss.any? {|s| test_schema(object, s) }
          raise InvalidObject.new(object: object)
        end
      end

      def ==(other)
        other.class == self.class &&
          other.path == path &&
          other.location == location &&
          other.id == id &&
          other.object == object
      end

      def hash
        super ^ object.hash
      end

      def valid?
        super && object
      end

      def as_json
        super.tap do |hash|
          hash[:object] = object
        end
      end

      def test_schema(object, schema)
        schema.coerce(object)
        true
      rescue StrongJSON::Type::UnexpectedAttributeError, StrongJSON::Type::TypeError
        false
      end
    end

    # Issue with plain text message, will be displayed to end-users as is.
    class Text < Base
      # @dynamic message, links
      attr_reader :message
      attr_reader :links

      def initialize(path:, location:, id:, message:, links:)
        @path = path
        @location = location
        @id = id
        @message = message
        @links = links
      end

      def ==(other)
        other.class == self.class &&
          other.path == path &&
          other.location == location &&
          other.id == id &&
          other.message == message &&
          other.links == links
      end

      def hash
        super ^ message.hash
      end

      def valid?
        super && message && links.is_a?(Array) && links.all? {|link| link.is_a?(String) }
      end

      def as_json
        super.tap do |hash|
          hash[:message] = message
          hash[:links] = links
        end
      end
    end
  end
end
