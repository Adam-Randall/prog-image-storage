RSpec.shared_examples_for 'a json response with errors' do |error_message = nil|
  before { subject }
  it { expect(400..499).to include subject.status }

  if error_message
    it 'returns the error messages' do
      expect(decoded_json_response['error']).to eq error_message
    end
  end
end
