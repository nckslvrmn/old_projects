Gem::Specification.new do |s|
  s.name = 'simple_crypt'
  s.version = '1.2.2'
  s.required_ruby_version = '>= 2.3.0'
  s.date = '2019-02-12'
  s.summary = 'A gem to encrypt and decrypt data using AES256-GCM and PBKDF using scrypt'
  s.author = 'Nick Silverman'
  s.license = 'GPL-3.0'
  s.files = Dir.glob('lib/**/*.rb')
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/nckslvrmn/simple_crypt'
  s.metadata = { 'source_code_uri' => 'https://github.com/nckslvrmn/simple_crypt' }
end
