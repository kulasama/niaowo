require 'resque'

class String

   def checksum
    ::Digest::MD5.hexdigest(self.to_s)
   end

end




class Resource < ActiveRecord::Base
  attr_accessible :count, :md5, :url



  ALLOW_TYPES={
  	'image/gif' => 'gif',
  	'image/png' => 'png',
  	'image/jpeg' => 'jpg',
  	'text/plain' => 'txt',
  	'application/octet-stream' => 'torrent',
  	'application/pdf' => 'pdf',
  }

  IMAGE_TYPES = [
  	'gif','png','jpg'
  ]

  IMAGE_TYPE = "image"
  DOWNLOAD_TYPE = "download"

  BUCKET = "niaowo_upload"


  TmpDir = "#{Rails.root}/public/upload/temp/"

  def self.temp_save(upfile)
  	if Resource::ALLOW_TYPES.include? upfile.content_type
  		subfix = Resource::ALLOW_TYPES[upfile.content_type]
  		
  		if subfix == 'torrent' 
  		  unless upfile.original_filename.end_with? "torrent"
  		  	return 
  		  end
  		end

  		stream = upfile.read
  		md5 = stream.checksum
  		item = Resource.find_by_md5 md5
  		if item
        return item
      else
  			unless
  			 Dir::exist? Resource::TmpDir
  				FileUtils.makedirs Resource::TmpDir
  			end
  			filename = "#{md5}.#{subfix}"
  			f = File.new "#{Resource::TmpDir}#{filename}","wb"
  			f.puts stream
  			f.close
  			resource = Resource.new
  			resource.md5 = md5
  			resource.filename = filename
  			resource.subfix = subfix
  			resource.count = 0
  			resource.save()
  			resource.async_push_s3
  			return resource
  		end
      
  	end
  end	

  def get_tmp_path
  	"#{Resource::TmpDir}#{self.filename}"
  end

  def get_url
    s3 = AWS::S3.new
    b = s3.buckets[Resource::BUCKET]
    o = b.objects["#{self.subfix}/#{self.filename}"]
    o.url_for(:read).to_s
  end


  def get_type
  	if Resource::IMAGE_TYPES.include? self.subfix
  		Resource::IMAGE_TYPE
  	else
  		Resource::DOWNLOAD_TYPE
  	end
  end

  def get_link_type
  	if self.subfix == 'pdf'
  		'application/pdf'
  	else
  		"application/octet-stream"
  	end
  end


  def push_s3
    p "push #{self.subfix}/#{self.filename} to s3"
    s3 = AWS::S3.new

    b = s3.buckets[Resource::BUCKET]
  
    o = b.objects["#{self.subfix}/#{self.filename}"]
    o.write(:file => self.get_tmp_path)
   
    File.delete self.get_tmp_path
    p "delete #{self.get_tmp_path}"
  end

  def async_push_s3
    Resque.enqueue(FileUploader,self.id)
  end





end
