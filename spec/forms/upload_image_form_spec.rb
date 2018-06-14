RSpec.describe UploadImageForm do
  include Rack::Test::Methods
  include_context 'file data'
  include_context 's3 client'

  let(:params) { { 'image_file' => file_to_upload } }
  let(:form)   { described_class.new params }

  describe '#save' do
    subject { form.save! }

    context 'is successful' do
      before do
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:bucket_name).and_return bucket_name
      end

      let(:result) { { success: aws_unique_identifier } }
      it { is_expected.to eq result }
    end

    context 'has unrecognised file' do
      let(:temp_file) { File.new ProgImageStorage.root.join('config/locales/en.yml') }
      let(:result) { { error: I18n.t('prog_image_storage.file_type_must_be_image') } }
      it { is_expected.to eq result }
    end

    context 'has wrong provider' do
      before do
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
        stubbed_client.stub_responses(:put_object, Timeout::Error)
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
      end

      let(:result) { { error: I18n.t('prog_image_storage.upload_file_failure', filename: image_name) } }
      it { is_expected.to eq result }
    end
  end
end
