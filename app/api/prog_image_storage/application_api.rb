module ProgImageStorage
  class ApplicationAPI < Grape::API
    format :json
    helpers ProgImageStorage::Helpers::ResponseApiHelpers

    mount Api::V10::Application

    desc 'Service and API versions'
    get :version do
      {
        service_version: ProgImageStorage::VERSION,
        api_version: ProgImageStorage::Settings.latest_api_version,
        author: 'Adam Randall'
      }
    end

    desc 'Service healthcheck'
    get :health do
      say_no_content
    end
  end
end
