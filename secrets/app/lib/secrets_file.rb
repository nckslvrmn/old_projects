# File to manage secrets files
class SecretFile
  def initialize(s3)
    @s3 = s3
  end

  def save(data, path)
    Aws.use_bundled_cert!
    @s3.put_object(
      bucket: ENV['S3_BUCKET'],
      body: data,
      acl: 'private',
      key: path + '.enc',
      server_side_encryption: 'aws:kms',
      ssekms_key_id: nil
    )
  end

  def retrieve(path)
    Aws.use_bundled_cert!
    @s3.get_object(
      bucket: ENV['S3_BUCKET'],
      key: path
    ).body.string
  end

  def check(path)
    begin
      Aws.use_bundled_cert!
      @s3.head_object(
        bucket: ENV['S3_BUCKET'],
        key: path
      )
    rescue Aws::S3::Errors::NotFound
      return false
    end
    true
  end

  def burn(path)
    Aws.use_bundled_cert!
    @s3.delete_object(
      bucket: ENV['S3_BUCKET'],
      key: path
    )
  end
end
