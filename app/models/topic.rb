
require 'rdiscount'


def onlyword(content)
  text = content.gsub(/\!\[.*\]\(.*\)/,"")
  text
end


class Topic < ActiveRecord::Base
  
  attr_accessible :body, :member_id, :message_id, :title,:deleted
  has_many :comments
  acts_as_taggable_on :tags
  belongs_to :member
  has_one :video
  validates :title, :presence => true
  validates :body, :presence => true

  searchable do
    text :title,:stored => true,:more_like_this => true
    text :body,:stored => true,:more_like_this => true
    integer :member_id
    text :comments,:stored=> true,:more_like_this => true  do
      comments.map { |comment| comment.body }
    end
    time :created_at
    text :topic_member,:stored=> true,:more_like_this => true do
      member.username
    end

    text :comments_member,:stored=> true,:more_like_this => true  do
      comments.map { |comment| comment.member.username }
    end
  end

  def self.praise(topic_id,member_id)
    key = "topics:#{topic_id}:praise"
    $redis.hincrby key,member_id,1
  end
  
  def self.pei(topic_id,member_id)
    key = "topics:#{topic_id}:pei"
    $redis.hincrby key,member_id,1
  end

  def self.praised?(topic_id,member_id)
    key = "topics:#{topic_id}:praise"
    val = $redis.hget key,member_id
    if val 
      return true
    else
      return false
    end
  end
  
  def self.pei?(topic_id,member_id)
    key = "topics:#{topic_id}:pei"
    val = $redis.hget key,member_id
    if val 
      return true
    else
      return false
    end
  end
  

  def self.get_praise(topic_id)
    key = "topics:#{topic_id}:praise"
    praise_count = $redis.hlen key
    praise_count = 0 unless praise_count
    praise_count
  end
  
  def self.get_pei(topic_id)
    key = "topics:#{topic_id}:pei"
    count = $redis.hlen key
    count = 0 unless count
    count
  end 

  def self.pv(id)
    key = "topics:pv:count"
    $redis.zincrby key,1,id
  end

  


  def self.get_pv(id)
    key = "topics:pv:count"
    pv = $redis.zscore key,id
    pv = 0 unless pv
    pv.to_i
  end

  def uv(view_id)
    key = "topics:#{self.id}:uv"
    $redis.hincrby key,view_id,1
  end

  def uv?(member_id)
    key = "topics:#{self.id}:uv"
    val = $redis.hget key,member_id
    if val 
      return true
    else
      return false
    end
  end

  def get_uv()
    key = "topics:#{self.id}:uv"
    uv = $redis.hlen key
    uv = 0 unless uv
    uv
  end


  def get_comments_count
    return Comment.count(:conditions => {:deleted=>false,:topic_id=> self.id})
  end

  def get_comments
    return Comment.where(:deleted=>false,:topic_id=>self.id).order("created_at")
  end

  def decr_view (point)
    self.viewpoint -= point
    if self.viewpoint < 0
      self.viewpoint = 0
    end
  end

  def incr_view (point)
    self.viewpoint += point
  end

  def view?(member_id)
    key = "topics:#{self.id}:#{member_id}:view"
    val = $redis.get key
    if val
      return true
    else
      return false
    end
  end

  def view(member_id)
    key = "topics:#{self.id}:#{member_id}:view"
    $redis.setex key,3600,1
  end


  def to_data
    
  	markdown = RDiscount.new(self.body)
    
    text = onlyword(self.body)
    data = {}
    data['id']  = self.id
    data['title'] = self.title
    data['viewpoint'] = self.viewpoint
    data['desc'] = text.slice(0,30) + "..."
    data['body'] =  markdown.to_html
    data['created'] = self.created_at
    data['author'] = self.member.username
    data
  end
  

end
