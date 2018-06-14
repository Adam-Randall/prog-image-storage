require 'pathname'

module ProgImageStorage
  class << self
    def env
      @env ||= ENV['RACK_ENV'] || 'development'
    end

    def root
      Pathname.new File.dirname(File.expand_path(__dir__))
    end
  end
end
