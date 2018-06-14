module ProgImageStorage
  module Api
    module V10
      class Images < Grape::API
        helpers do
          def upload_permitted_params
            params.slice *UploadImageForm.permitted_params
          end

          def upload_form
            UploadImageForm.new upload_permitted_params
          end

          def convert_permitted_params
            params.slice *ConvertForm.permitted_params
          end

          def convert_form
            ConvertForm.new convert_permitted_params
          end

          def successful_response response
            say_created
            present url: response[:success], with: Entities::UniqueIdentifier
          end
        end

        namespace :images do
          # /v1.0/images/upload
          resource :upload do
            desc 'Upload image file to the cloud'
            params do
              requires :image_file, type: File, desc: 'Image to upload'
            end
            post do
              response = upload_form.save!
              response.key?(:success) ? successful_response(response) : say_error(response)
            end
          end

          # /v1.0/images/convert
          resource :convert do
            desc 'Convert different image format base on URL request'
            params do
              requires :request_url, type: String, desc: 'Image URL to change extension to'
            end
            post do
              response = convert_form.convert!
              response.key?(:success) ? successful_response(response) : say_error(response)
            end
          end
        end
      end
    end
  end
end
