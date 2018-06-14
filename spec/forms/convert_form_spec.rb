RSpec.describe ConvertForm do
  include Rack::Test::Methods
  include_context 'file data'
  include_context 's3 client'

  let(:url)    { aws_unique_identifier.sub('jpg', 'png') }
  let(:params) { { 'request_url' => url } }
  let(:form)   { described_class.new params }

  describe '#convert' do
    subject { form.convert! }

    context 'is successful' do
      let(:result) { { success: url } }
      before do
        allow_any_instance_of(ImageConverter).to receive(:delete_old_image).and_return true
        allow_any_instance_of(ConvertForm).to receive(:file_exists?).and_return true
        allow_any_instance_of(ConvertForm).to receive(:old_image_file).and_return image.to_s
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
      end

      it { is_expected.to eq result }
    end

    context 'is unknown image file extension' do
      let(:new_image_name) { image_name.sub('jpg', 'png') }
      let(:result)         { { error: I18n.t('prog_image_storage.unknown_image_file', image_name: new_image_name) } }

      before { allow_any_instance_of(ConvertForm).to receive(:file_exists?).and_return false }

      it { is_expected.to eq result }
    end

    context 'is unknown image file' do
      let(:extension) { 'txt' }
      let(:url)       { aws_unique_identifier.sub('jpg', extension) }
      let(:result)    { { error: I18n.t('prog_image_storage.unknown_extension', extension: extension) } }

      before { allow_any_instance_of(ConvertForm).to receive(:file_exists?).and_return true }

      it { is_expected.to eq result }
    end
  end
end
