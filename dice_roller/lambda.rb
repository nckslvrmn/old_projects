require 'json'
require 'rack'

$app ||= Rack::Builder.parse_file("#{File.dirname(__FILE__)}/app/config.ru").first

def handler(event:, context:)
  body = if event['isBase64Encoded']
           Base64.decode64(event['body'])
         else
           event['body']
         end || ''

  env = {
    'REQUEST_METHOD' => event['requestContext']['http']['method'],
    'SCRIPT_NAME' => '',
    'PATH_INFO' => event['requestContext']['http']['path'],
    'QUERY_STRING' => event['queryStringParameters'] || '',
    'SERVER_NAME' => event['headers']['host'],
    'SERVER_PORT' => event['headers']['x-forwarded-port'],
    'rack.version' => Rack::VERSION,
    'rack.url_scheme' => event['headers']['x-forwarded-proto'],
    'rack.input' => StringIO.new(body),
    'rack.errors' => $stderr
  }

  unless event['headers'].nil?
    event['headers'].each { |key, value| env["HTTP_#{key}"] = value }
  end

  status, headers, body = $app.call(env)
  body_content = ''
  body.each do |item|
    body_content += item.to_s
  end

  response = {
    'statusCode' => status,
    'headers' => headers,
    'body' => body_content
  }
  response
end
