module ProgImageStorage
  class Settings
    class << self
      def api_versions
        %w[v1.0]
      end

      def latest_api_version
        api_versions.last
      end

      def exposed_api_versions_for version
        api_versions.drop_while { |v| version != v }
      end
    end
  end
end
