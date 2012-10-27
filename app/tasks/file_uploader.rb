
class FileUploader
  @queue = :upload_files

  def self.perform(repo_id)
    file = Resource.find(repo_id)
    file.push_s3
  end

end
