module Errors
  class CloudProviderDoesNotExist < StandardError
    def initialize
      super I18n.t 'prog_image_storage.cloud_provider_does_not_exist'
    end
  end

  class FileAccessFailure < StandardError
    def initialize filename
      super I18n.t 'prog_image_storage.file_access_failure', filename: filename
    end
  end

  class UploadFileFailure < StandardError
    def initialize filename
      super I18n.t 'prog_image_storage.upload_file_failure', filename: filename
    end
  end

  class ImageExists < StandardError
    def initialize filename
      super I18n.t 'prog_image_storage.image_exists', filename: filename
    end
  end

  class UnknownExtension < StandardError
    def initialize extension
      super I18n.t 'prog_image_storage.unknown_extension', extension: extension
    end
  end

  class ImageNotFound < StandardError
    def initialize image_name
      super I18n.t 'prog_image_storage.unknown_image_file', image_name: image_name
    end
  end
end
