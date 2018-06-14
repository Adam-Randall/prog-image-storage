module ProgImageStorage
  module Helpers
    module ResponseApiHelpers
      def say_error response, status = 422
        error! response, status
      end

      def say_ok
        status 200
      end

      def say_created
        status 201
      end

      def say_no_content
        @body = ''
        status 204
      end
    end
  end
end
