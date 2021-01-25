require 'base64'
require 'openssl'
require 'securerandom'
require_relative 'simple_crypt/secret'

# encrypts and stores and decrypts secrets
module SimpleCrypt
  def self.encrypt(data, pwd)
    iv = OpenSSL::Random.random_bytes(12)
    salt = OpenSSL::Random.random_bytes(16)
    auth_data = SecureRandom.random_bytes(16)
    key = gen_key(pwd, salt)

    cipher = OpenSSL::Cipher.new('aes-256-gcm')
    cipher.encrypt
    cipher.iv = iv
    cipher.key = key
    cipher.auth_data = auth_data

    sec = SimpleCrypt::Secret.new
    sec.secret_data = Base64.strict_encode64(cipher.update(data) + cipher.final)
    sec.iv = Base64.strict_encode64(iv)
    sec.salt = Base64.strict_encode64(salt)
    sec.auth_tag = Base64.strict_encode64(cipher.auth_tag)
    sec.auth_data = Base64.strict_encode64(auth_data)
    sec
  end

  def self.decrypt(secret, pwd)
    salt = Base64.strict_decode64(secret.salt)
    secret_data = Base64.strict_decode64(secret.secret_data)

    decipher = OpenSSL::Cipher.new('aes-256-gcm')
    decipher.decrypt
    decipher.iv = Base64.strict_decode64(secret.iv)
    decipher.key = gen_key(pwd, salt)
    decipher.auth_tag = Base64.strict_decode64(secret.auth_tag)
    decipher.auth_data = Base64.strict_decode64(secret.auth_data)

    begin
      decrypted = decipher.update(secret_data) + decipher.final
      return decrypted
    rescue OpenSSL::Cipher::CipherError
      return nil
    end
  end

  private_class_method def self.gen_key(pwd, salt)
    OpenSSL::KDF.scrypt(pwd, salt: salt, N: 2**14, r: 8, p: 1, length: 32)
  end
end
