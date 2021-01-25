require 'base64'
require 'simple_crypt'
require_relative 'secrets'
require_relative 'secrets_file'

# encrypts and stores and decrypts secrets
class Cryptor
  def sanitize_view_count(view_count)
    vc = view_count.to_i.abs
    if vc.nil?
      1
    elsif vc.zero?
      1
    elsif vc > 10
      10
    else
      vc
    end
  end

  def gen_passphrase
    Base64.encode64(OpenSSL::Random.random_bytes(32)).strip
  end

  def encrypt(data, pwd, view_count, s3, file_name = nil)
    if file_name
      encrypt_file(data, pwd, file_name, s3)
    else
      encrypt_string(data, pwd, view_count)
    end
  end

  def decrypt(secret_id, pwd, s3)
    Aws.use_bundled_cert!
    record = Secrets.find(secret_id: secret_id)
    return nil if record.nil?

    decrypted = if record.s3_info
                  decrypt_file(record, pwd, s3)
                else
                  decrypt_string(record, pwd)
                end
    return nil if decrypted.nil?

    decrypted
  end

  private

  def encrypt_string(data, pwd, view_count)
    secret_id = SecureRandom.urlsafe_base64(16)
    secret = SimpleCrypt.encrypt(data, pwd)
    Aws.use_bundled_cert!
    record = Secrets.new
    record.secret_id = secret_id
    record.ttl = (Time.now + (86_400 * (ENV.fetch('TTL_DAYS', 5).to_i))).to_i
    record.view_count = sanitize_view_count(view_count)
    record.secret_data = secret.secret_data
    record.iv = secret.iv
    record.salt = secret.salt
    record.auth_tag = secret.auth_tag
    record.auth_data = secret.auth_data
    record.save!
    secret_id
  end

  def encrypt_file(data, pwd, file_name, s3)
    secret_id = SecureRandom.urlsafe_base64(16)
    secret = SimpleCrypt.encrypt(data, pwd)
    sf = SecretFile.new(s3)
    sf.save(secret.secret_data, secret_id)
    Aws.use_bundled_cert!
    record = Secrets.new
    record.secret_id = secret_id
    record.file_name = file_name
    record.ttl = (Time.now + (86_400 * (ENV.fetch('TTL_DAYS', 5).to_i))).to_i
    record.view_count = 1
    record.s3_info = { bucket: ENV['S3_BUCKET'], key: secret_id + '.enc' }.to_json
    record.secret_data = nil
    record.iv = secret.iv
    record.salt = secret.salt
    record.auth_tag = secret.auth_tag
    record.auth_data = secret.auth_data
    record.save!
    secret_id
  end

  def decrypt_string(record, pwd)
    secret = SimpleCrypt::Secret.new(
      record.secret_data,
      record.iv,
      record.salt,
      record.auth_tag,
      record.auth_data
    )
    decrypted = SimpleCrypt.decrypt(secret, pwd)
    return nil if decrypted.nil?

    burn(record)
    { data: decrypted }
  end

  def decrypt_file(record, pwd, s3)
    s3_info = JSON.parse(record.s3_info)
    sf = SecretFile.new(s3)
    return nil unless sf.check(s3_info['key'])

    file_data = sf.retrieve(s3_info['key'])
    secret = SimpleCrypt::Secret.new(
      file_data,
      record.iv,
      record.salt,
      record.auth_tag,
      record.auth_data
    )
    decrypted = SimpleCrypt.decrypt(secret, pwd)
    sf.burn(s3_info['key'])
    burn(record)
    { data: Base64.strict_encode64(decrypted), file_name: record.file_name }
  end

  def burn(record)
    if record.view_count <= 1
      record.delete!
    else
      record.view_count = record.view_count - 1
      record.save
    end
  end
end
