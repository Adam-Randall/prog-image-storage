RSpec.shared_context 'file data', shared_context: :metadata do
  let(:image_name)            { 'allblacks.jpg' }
  let(:image)                 { ProgImageStorage.root.join 'spec', 'images', image_name }
  let(:temp_file)             { Rack::Test::UploadedFile.new(image, 'image/jpeg') }
  let(:bucket_name)           { 'test-bucket' }
  let(:region)                { 'eu-west-1' }
  let(:aws_unique_identifier) { "https://#{bucket_name}.s3.#{region}.amazonaws.com/#{image_name}" }
  let :file_to_upload do
    ActiveSupport::HashWithIndifferentAccess.new \
      type: 'image/jpg',
      filename: image_name,
      tempfile: temp_file,
      head: {}
  end
end
