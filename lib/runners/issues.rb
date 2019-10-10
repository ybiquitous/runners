module Runners
  module Issues
    class InvalidIssueError < StandardError
      attr_reader :issue

      def initialize(issue:)
        @issue = issue
      end
    end

    class Base
      attr_reader :path
      attr_reader :location
      attr_reader :id

      def initialize(path:, location:, id:)
        @path = path
        @location = location
        @id = id
      end

      def ensure_validity
        if valid?
          yield
        else
          raise InvalidIssueError.new(issue: self), errors.join("\n")
        end
      end

      def eql?(other)
        self == other
      end

      def hash
        path.hash ^ location.hash ^ id.hash
      end

      def valid?
        unless path.instance_of?(Pathname)
          errors << "Invalid path: #{path.inspect}"
        end
        if id.nil? || id.empty?
          errors << "Empty `id`"
        end
        errors.empty?
      end

      def errors
        @errors ||= []
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

    # Issue with structure, will be formatted later, maybe by frontend
    class Structured < Base
      attr_reader :object
      attr_reader :schema

      def initialize(path:, location:, id:, object:, schema:)
        super(path: path, location: location, id: id)
        @object = object
        @schema = schema
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
        super

        if object
          ss = Array(schema)
          unless ss.empty? || ss.any? { |s| test_schema(object, s) }
            errors << "Invalid `object`: #{object.inspect}"
          end
        else
          errors << "Empty `object`"
        end

        errors.empty?
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
      attr_reader :message
      attr_reader :links

      def initialize(path:, location:, id:, message:, links:)
        super(path: path, location: location, id: id)
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
        super

        unless message && !message.empty?
          errors << "Empty `message`"
        end
        unless links.is_a?(Array)
          errors << "Not an array: `links`"
        end
        unless links.all? {|link| link.is_a?(String) }
          errors << "Not a string array: `links`"
        end

        errors.empty?
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
