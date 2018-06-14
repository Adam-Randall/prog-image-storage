class UploadImageForm < BaseForm
  attr_accessor :image_file

  def self.permitted_params
    %i[image_file]
  end

  def initialize params
    @image_file = params['image_file']
    @errors = {}
  end

  def save!
    return errors unless validate_file

    storage.upload! image_file
    unique_identifier = storage.unique_identifier_for_file image_file['filename']
    { success: unique_identifier }
  rescue Errors::CloudProviderDoesNotExist, Errors::FileAccessFailure,
         Errors::ImageExists, Errors::UploadFileFailure => exception
    errors[:error] = exception.message
    errors
  end

  private

    def validate_file
      validate_property image_file?, I18n.t('prog_image_storage.file_type_must_be_image')
    end

    def image_file?
      MimeMagic.by_magic(image_file['tempfile']).image?
    rescue NoMethodError
      false
    end
end
