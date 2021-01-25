require 'json'
require 'sqlite3'

# class for the bungie world database and lookup methods
class BungieDB
  def initialize(db_file_name)
    @db = SQLite3::Database.open(File.join('./world_db', db_file_name))
    @db.results_as_hash = true
  end

  def lookup_data(lookup_id, db_name)
    data = @db.execute <<-SQL
    select * from "Destiny#{db_name}Definition"  where id == "#{overflow(lookup_id)}";
    SQL
    return nil if data[0].nil?
    json_data = JSON.parse(data[0]['json'])
    json_data['displayProperties']['name']
  end

  def overflow(i)
    ((i + 2**31) % 2**32) - 2**31
  end
end
