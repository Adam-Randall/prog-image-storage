require 'aws-sdk-s3'

module CloudProviders
  module AWS
    class S3Client
      attr_accessor :client

      def initialize
        @client ||= Aws::S3::Client.new region: region, credentials: credentials
      end

      def upload_image image_file, filename
        upload_file! image_file, filename
        true
      end

      def public_image_url filename
        s3_object = resource.bucket(bucket_name).object filename
        s3_object.public_url
      end

      def check_image_exists? file_name
        return true if retrieve_image file_name
      end

      def retrieve_image key
        client.get_object bucket: bucket_name, key: key
      rescue Aws::S3::Errors::NoSuchKey
        false
      end

      private

        def upload_file! image_file, filename
          object = { body: image_file, bucket: bucket_name, key: filename, acl: 'public-read' }
          client.put_object object

          store_generic_image! filename
        rescue Aws::S3::Errors, Timeout::Error
          raise Errors::UploadFileFailure.new filename
        end

        def store_generic_image! filename
          generic_key_name = /.*(?=\.)/.match(filename).to_s
          return if check_image_exists? generic_key_name

          object = { copy_source: "#{bucket_name}/#{filename}", bucket: bucket_name, key: generic_key_name }
          client.copy_object object
        rescue Aws::S3::Errors, Timeout::Error
          raise Errors::UploadFileFailure.new generic_key_name
        end

        def resource
          @resource ||= Aws::S3::Resource.new region: region, credentials: credentials
        end

        def credentials
          @credentials ||= Aws::Credentials.new aws_access_key_id, aws_secret_access_key
        end

        def region
          Figaro.env.region!
        end

        def aws_access_key_id
          Figaro.env.aws_access_key_id!
        end

        def aws_secret_access_key
          Figaro.env.aws_secret_access_key!
        end

        def bucket_name
          Figaro.env.bucket_name!
        end
    end
  end
end
