RSpec.shared_examples_for 'a successful response' do
  before { subject }
  it { expect(200..299).to include subject.status }
end
