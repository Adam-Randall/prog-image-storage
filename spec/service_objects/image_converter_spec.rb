RSpec.describe ImageConverter do
  include Rack::Test::Methods
  include_context 'file data'

  let(:extension)       { configatron.supported_image_types.sample }
  let(:params)          { { extension: extension, image_name: 'all_blacks.png', old_image_file: image } }
  let(:image_converter) { described_class.new params }

  describe '#convert' do
    subject { image_converter.convert }

    before { allow_any_instance_of(ImageConverter).to receive(:delete_old_image).and_return true }

    its(['format']) { is_expected.to eq extension }
  end
end
