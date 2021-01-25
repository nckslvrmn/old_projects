require 'json'
require 'openssl.rb'
require 'base64'
require_relative './app/server'

def handler(event:, context:)
  raw_body = event['isBase64Encoded'] ? Base64.decode64(event['body']) : event['body']
  body = begin
           JSON.parse(raw_body)
         rescue JSON::ParserError
           raw_body
         end

  env = {
    method: event['requestContext']['httpMethod'],
    path: event['requestContext']['path'],
    params: event['queryStringParameters'] || '',
    body: body
  }

  resp = router(env)
  resp[:isBase64Encoded] = false
  resp[:headers] ||= { 'Content-Type': 'application/json' }
  resp.transform_keys(&:to_s)
end
