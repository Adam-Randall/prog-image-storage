RSpec.describe CloudProviders::AWS::S3Client do
  include Rack::Test::Methods
  include_context 'file data'
  include_context 's3 client'

  let(:s3_client) { described_class.new }

  describe '#upload' do
    subject { s3_client.upload_image file_to_upload['tempfile'], image_name }

    context 'is successful' do
      before do
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
      end

      it { is_expected.to eq true }
    end

    context 'is unsuccessful with upload file' do
      before do
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
        stubbed_client.stub_responses(:put_object, Timeout::Error)
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
      end

      it { expect { subject }.to raise_error Errors::UploadFileFailure }
    end
  end

  describe '#public_url' do
    subject { s3_client.public_image_url image_name }

    context 'url containing image' do
      before do
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:bucket_name).and_return bucket_name
        allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:region).and_return region
      end

      it { is_expected.to eq aws_unique_identifier }
    end
  end
end
