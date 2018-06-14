RSpec.describe CloudStorage do
  include Rack::Test::Methods
  include_context 'file data'
  include_context 's3 client'

  let(:cloud_storage) { described_class.new provider }

  describe '#upload' do
    subject { cloud_storage.upload! file_to_upload }

    before do
      allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:check_image_exists?).and_return false
      allow_any_instance_of(CloudProviders::AWS::S3Client).to receive(:client).and_return stubbed_client
    end

    context 'when cloud provider is supported' do
      let(:provider) { 'AWS' }
      it { is_expected.to eq true }
    end

    context 'when cloud provider is not supported' do
      let(:provider) { 'Google' }
      it { expect { subject }.to raise_error Errors::CloudProviderDoesNotExist }
    end
  end
end
