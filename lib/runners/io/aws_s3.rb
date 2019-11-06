# AwsS3IO expects AWS credentials set with environment variables or an instance profile.
# So, before using this, make sure AWS credentials available.
# Also, prepare the S3 bucket and allow this instance to upload an S3 object.
module Runners
  class IO::AwsS3
    def self.parse_s3_uri!(s3_uri)
      uri = URI(s3_uri)
      bucket = uri.host.presence
      object = uri.path.presence
      if uri.scheme == "s3" && bucket && object
        [bucket, object.delete_prefix("/")]
      else
        raise "The specified S3 URI is not valid. You specified with '#{s3_uri}'"
      end
    end

    attr_reader :uri, :bucket_name, :object_name, :tempfile, :client
    delegate :write, :flush, to: :tempfile

    # @param uri [String]
    def initialize(uri)
      @uri = uri
      @bucket_name, @object_name = self.class.parse_s3_uri!(uri)
      @tempfile = Tempfile.new

      args = {
        retry_limit: 5,
        retry_base_delay: 1.2,
      }.tap do |hash|
        if ENV["S3_ENDPOINT"]
          hash[:endpoint] = ENV["S3_ENDPOINT"]
          hash[:force_path_style] = true
        end
      end
      @client = Aws::S3::Client.new(**args)
    end

    def finalize!
      tempfile.rewind
      client.put_object(
        bucket: bucket_name,
        key: object_name,
        body: tempfile,
      )
    end
  end
end
