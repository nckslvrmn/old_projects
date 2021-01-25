# stores secret info as a class
module SimpleCrypt
  class Secret
    attr_accessor :secret_data, :iv, :salt, :auth_tag, :auth_data

    def initialize(secret_data = nil, iv = nil, salt = nil, auth_tag = nil, auth_data = nil)
      @secret_data = secret_data
      @iv = iv
      @salt = salt
      @auth_tag = auth_tag
      @auth_data = auth_data
    end
  end
end
