class BaseForm
  attr_accessor :params, :errors

  private

    def storage
      @storage ||= CloudStorage.new storage_provider
    end

    def storage_provider
      Figaro.env.provider!
    end

    def validate_property callback, error_message
      if callback
        true
      else
        errors[:error] = error_message
        false
      end
    end
end
