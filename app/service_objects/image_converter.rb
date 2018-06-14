class ImageConverter
  attr_accessor :extension, :image_name, :old_image_file

  def initialize params
    @extension = params[:extension]
    @image_name = params[:image_name]
    @old_image_file = params[:old_image_file]
  end

  def convert
    new_image = MiniMagick::Image.open open_file_image
    new_image.format extension
    delete_old_image
    new_image
  end

  private

    def open_file_image
      File.new old_image_file
    end

    def delete_old_image
      File.delete old_image_file
    end
end
