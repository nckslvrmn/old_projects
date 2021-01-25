require 'json'
require 'aws-sdk-s3'
require 'base64'
require_relative './lib/cryptor'

def encrypt(env, crypt, s3)
  view_count = crypt.sanitize_view_count(env[:body]['view_count'])
  passphrase = crypt.gen_passphrase
  secret_id = if env[:params]['file_name']
                crypt.encrypt(
                  env[:body],
                  passphrase,
                  1,
                  s3,
                  env[:params]['file_name']
                )
              else
                crypt.encrypt(
                  env[:body]['secret'],
                  passphrase,
                  view_count,
                  s3
                )
              end
  { statusCode: 200, body: { secret_id: secret_id, passphrase: passphrase }.to_json }
end

def decrypt(env, crypt, s3)
  data = crypt.decrypt(env[:body]['secret_id'], env[:body]['passphrase'], s3)
  resp = if data.nil? || data[:data].nil?
           { statusCode: 404, body: nil }
         elsif data[:file_name]
           puts data
           { statusCode: 200, body: data.to_json }
         else
           { statusCode: 200, body: { data: data[:data] }.to_json }
         end
  resp
end

def router(env)
  Aws.use_bundled_cert!
  s3 = Aws::S3::Client.new
  crypt = Cryptor.new
  case env[:path]
  when '/encrypt'
    encrypt(env, crypt, s3)
  when '/decrypt'
    decrypt(env, crypt, s3)
  end
end
