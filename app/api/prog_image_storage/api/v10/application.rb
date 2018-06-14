module ProgImageStorage
  module Api
    module V10
      class Application < Grape::API
        version ProgImageStorage::Settings.exposed_api_versions_for 'v1.0'

        mount Api::V10::Images
      end
    end
  end
end
