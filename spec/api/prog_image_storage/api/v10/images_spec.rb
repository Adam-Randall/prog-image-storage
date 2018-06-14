RSpec.describe ProgImageStorage::Api::V10::Images, type: :request do
  include Rack::Test::Methods
  include_context 'file data'
  include_context 's3 client'
  let(:image_params) { {} }

  def dispatch method = :post, params = image_params
    send method, "/v1.0/images/#{path}", params
  end

  describe 'POST /v1.0/images/upload' do
    let(:path) { 'upload' }
    let(:image_params) { { image_file: temp_file } }

    subject { dispatch }

    context 'successful' do
      before do
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
      end
      it_behaves_like 'a successful response'
    end

    describe 'failure' do
      context 'no file added to params' do
        let(:image_params) { { image_file: 'string' } }
        before do
          allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
          allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
        end

        it_behaves_like 'a json response with errors'
      end

      context 'no recognised provider' do
        before do
          allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
          allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
          allow_any_instance_of(UploadImageForm).to receive(:storage_provider).and_return 'Google'
        end
        it_behaves_like 'a json response with errors', I18n.t('prog_image_storage.cloud_provider_does_not_exist')
      end

      context 'failure to upload' do
        before do
          allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
          stubbed_client.stub_responses(:put_object, Timeout::Error)
          allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
        end

        it_behaves_like 'a json response with errors'
        it 'has correct error message' do
          subject
          error_message = I18n.t('prog_image_storage.upload_file_failure', filename: image_name)
          expect(decoded_json_response['error']).to eq error_message
        end
      end
    end
  end

  describe 'POST /v1.0/images/convert' do
    let(:path) { 'convert' }
    let(:image_params) { { request_url: request_url } }

    subject { dispatch }

    context 'successful' do
      let(:request_url)  { "#{/.*(?=\.)/.match(image.to_s)}.png" }

      before do
        allow_any_instance_of(ImageConverter).to receive(:delete_old_image).and_return true
        allow_any_instance_of(ConvertForm).to receive(:file_exists?).and_return true
        allow_any_instance_of(ConvertForm).to receive(:old_image_file).and_return image.to_s
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
      end

      it_behaves_like 'a successful response'
    end

    describe 'failure' do
      context 'is unknown image file' do
        let(:request_url) { 'test.jpg' }
        let(:image_params) { { request_url: request_url } }

        before { allow_any_instance_of(ConvertForm).to receive(:file_exists?).and_return false }

        it_behaves_like 'a json response with errors'
        it 'has correct error message' do
          subject
          error_message = I18n.t('prog_image_storage.unknown_image_file', image_name: request_url)
          expect(decoded_json_response['error']).to eq error_message
        end
      end

      context 'is unknown image extension' do
        let(:extension) { 'txt' }
        let(:request_url) { "test.#{extension}" }

        before { allow_any_instance_of(ConvertForm).to receive(:file_exists?).and_return true }

        it_behaves_like 'a json response with errors'
        it 'has correct error message' do
          subject
          error_message = I18n.t('prog_image_storage.unknown_extension', extension: extension)
          expect(decoded_json_response['error']).to eq error_message
        end
      end
    end
  end
end
