require 'rdiscount'
class Comment < ActiveRecord::Base
  attr_accessible :body, :member_id, :message_id, :topic_id
  belongs_to :topic
  belongs_to :member
  validates :body, :presence => true

  def self.praise(comment_id,member_id)
    key = "comments:#{comment_id}:praise"
    $redis.hincrby key,member_id,1
  end

  def self.praised?(comment_id,member_id)
    key = "comments:#{comment_id}:praise"
    val = $redis.hget key,member_id
    if val 
      return true
    else
      return false
    end
  end

  def self.get_praise(comment_id)
    key = "comments:#{comment_id}:praise"
    praise_count = $redis.hlen key
    praise_count = 0 unless praise_count
    praise_count
  end
  
  def self.pei(comment_id,member_id)
      key = "comments:#{comment_id}:pei"
      $redis.hincrby key,member_id,1
  end

  def self.get_pei(comment_id)
    key = "comments:#{comment_id}:pei"
    pei_count = $redis.hlen key
    pei_count = 0 unless pei_count
    pei_count
  end
  
  def to_data
    data = {}
    markdown = RDiscount.new(self.body)
    data['id']  = self.id
    data['body'] = markdown.to_html
    data['author'] = self.member.username
    data['created'] = self.created_at
    data
  end
  
end
