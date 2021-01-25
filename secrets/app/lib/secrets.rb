require 'aws-record'

# defines active record class for secrets
class Secrets
  include Aws::Record
  string_attr :secret_id, hash_key: true
  string_attr :file_name
  string_attr :secret_data
  string_attr :iv
  string_attr :salt
  string_attr :auth_tag
  string_attr :auth_data
  string_attr :s3_info
  integer_attr :view_count
  epoch_time_attr :ttl
end
