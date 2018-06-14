RSpec.shared_context 's3 client', shared_context: :metadata do
  let(:stubbed_client) { Aws::S3::Client.new(stub_responses: true) }
end
