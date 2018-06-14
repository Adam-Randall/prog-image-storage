require File.expand_path('../config/prog_image_storage.rb', __dir__)
require File.expand_path('../config/environment.rb', __dir__)
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, ProgImageStorage.env)

# Load any pre-app initializers
require ProgImageStorage.root.join 'config/intializers/settings.rb'

# Setup figaro
Figaro.application = Figaro::Application.new \
  environment: ProgImageStorage.env,
  path: ProgImageStorage.root.join('config', 'application.yml')
Figaro.load

# Loading files
require_all ProgImageStorage.root.join 'app/lib'
require_all ProgImageStorage.root.join 'app/service_objects'
require_all ProgImageStorage.root.join 'app/forms'
require_all ProgImageStorage.root.join 'app/api/prog_image_storage/helpers'
require_all ProgImageStorage.root.join 'app/api/prog_image_storage/entities'
require_all ProgImageStorage.root.join 'app/api/prog_image_storage/errors'
require_all Dir.glob('app/api/prog_image_storage/api/v10/*.rb').reject { |f| f.include?('application.rb') }
require ProgImageStorage.root.join('app/api/prog_image_storage/api/v10/application.rb')
require_all ProgImageStorage.root.join 'app/api/prog_image_storage/*.rb'

I18n.load_path = Dir[ProgImageStorage.root.join('config/locales/*.yml')]
