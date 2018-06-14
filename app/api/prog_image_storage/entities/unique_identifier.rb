module Entities
  class UniqueIdentifier < Grape::Entity
    expose :url, documentation: { type: 'string' }
  end
end
