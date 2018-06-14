def decoded_json_response text = last_response.body
  JSON.parse text
end

def decoded_json_status
  last_response.status
end

def app
  ProgImageStorage::ApplicationAPI
end
