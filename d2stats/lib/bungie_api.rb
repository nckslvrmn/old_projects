require 'httparty'

# class of api calls for destiny
class BungieAPI
  include HTTParty
  base_uri 'https://www.bungie.net'

  def initialize(conf)
    @conf = conf
    @headers = { 'X-API-Key' => conf['api_key'] }
  end

  def download_manifest(filename, uri)
    File.open(filename, 'w') do |file|
      file.binmode
      self.class.get(uri, stream_body: true) do |fragment|
        file.write(fragment)
      end
    end
  end

  def http_get(query_uri)
    query_uri = "/platform/destiny2#{query_uri}"
    start_time = Time.now
    response = self.class.get(query_uri, headers: @headers)
    rt = ((Time.now - start_time) * 1000).to_i
    puts "#{response.code} from #{query_uri} in #{rt}ms" if @conf['verbose']
    puts response.body if @conf['debug']
    response.parsed_response['Response']
  end

  def fetch_manifest
    http_get('/manifest/')
  end

  def fetch_member_id
    data = http_get("/SearchDestinyPlayer/#{@conf['membership_type']}/#{@conf['display_name']}/")
    @member_id = data[0]['membershipId']
  end

  def fetch_characters
    http_get("/#{@conf['membership_type']}/profile/#{@member_id}/?components=200")
  end

  def fetch_equipment
    http_get("/#{@conf['membership_type']}/profile/#{@member_id}/?components=205")
  end

  def fetch_item(item_id)
    http_get("/#{@conf['membership_type']}/Profile/#{@member_id}/Item/#{item_id}/?components=300")
  end
end
