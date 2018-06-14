class CloudStorage
  attr_accessor :provider

  def initialize provider
    @provider = provider
  end

  def retrieve_image! key
    raise Errors::ImageNotFound.new(key) unless image_exist? key

    s3_object = storage_provider.retrieve_image(key)
    File.open("tmp/#{key}", 'w+') do |file|
      file.write s3_object.body.read
      file
    end
  end

  def image_exist? filename
    storage_provider.check_image_exists? filename
  end

  def upload! image_file, filename = nil
    filename ||= image_file['filename']

    raise Errors::ImageExists.new(image_file['filename']) if image_exist? filename

    file_to_upload = image_file.class == MiniMagick::Image ? image_file.tempfile : image_file['tempfile']
    storage_provider.upload_image file_to_upload, filename
  end

  def unique_identifier_for_file filename
    storage_provider.public_image_url filename
  end

  private

    def storage_provider
      @storage_provider ||= determine_provider!
    end

    def determine_provider!
      case provider
      when 'AWS'
        CloudProviders::AWS::S3Client.new
      else
        raise Errors::CloudProviderDoesNotExist.new
      end
    end
end
