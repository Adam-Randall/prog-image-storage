class ConvertForm < BaseForm
  attr_accessor :request_url, :extension, :key, :image_name

  def self.permitted_params
    %i[request_url]
  end

  def initialize params
    @request_url = params['request_url']
    @image_name = request_url.split('/').last
    @key, @extension = image_name.split('.')
    @errors = {}
  end

  def convert!
    return errors unless validate!
    { success: unique_identifier }
  rescue Errors::CloudProviderDoesNotExist, Errors::FileAccessFailure,
         Errors::ImageExists, Errors::UploadFileFailure => exception
    errors[:error] = exception.message
    errors
  end

  private

    def unique_identifier
      file_exists?(image_name) ? request_url : converted_image_identifier
    end

    def converted_image_identifier
      new_file = convert_image
      storage.upload! new_file, image_name
      storage.unique_identifier_for_file image_name
    end

    def convert_image
      ImageConverter.new(convert_image_params).convert
    end

    def convert_image_params
      {
        image_name: image_name,
        extension: extension,
        old_image_file: old_image_file
      }
    end

    def validate!
      validate_file_exists? && validate_extension?
    end

    def validate_file_exists?
      validate_property file_exists?(key), I18n.t('prog_image_storage.unknown_image_file', image_name: image_name)
    end

    def validate_extension?
      validate_property image_extension?, I18n.t('prog_image_storage.unknown_extension', extension: extension)
    end

    def image_extension?
      MimeMagic.by_extension(extension).image?
    rescue NoMethodError
      false
    end

    def file_exists? filename
      storage.image_exist? filename
    end

    def old_image_file
      storage.retrieve_image! key
    end
end
