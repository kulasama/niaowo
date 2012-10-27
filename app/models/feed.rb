require 'yaml'  
class Feed < ActiveRecord::Base
  attr_accessible :action, :data, :member_id
  
  ALL_TYPE = "all"
  MENTION_TYPE = "mention"
  COMMENTED_TYPE = "commented"
  TOPIC_PRAISE_TYPE  = "topic_praise"
  COMMENT_PRAISE_TYPE = "comment_praise"
  PRAISE_TYPE = "praise"
  SENSE_TYPE = "sense"
  TOPIC_TYPE = "topic"
  COMMENT_TYPE = "comment"

  def get_value
    YAML.load(self.data)
  end


  def self.sense(uid,num)
    feed = Feed.new
    feed.member_id = uid
    feed.action = Feed::SENSE_TYPE
    feed.data = {
      :sense_num => num
    }
    feed.save!
    Member.sense uid,num
    return feed
  end

  def self.mention(uid,sender_id,topic_id)
    feed = Feed.new 
    feed.member_id = uid
    feed.action = Feed::MENTION_TYPE
    feed.data = {
        :sender_id => sender_id,
        :topic_id => topic_id
    }
    feed.save!
    Member.mention uid
    return feed
  end

  def self.commented(uid,sender_id,topic_id)          
      feed = Feed.new 
      feed.member_id = uid
      feed.action = Feed::COMMENTED_TYPE
      feed.data = {
        :sender_id => sender_id,
        :topic_id =>topic_id
      }
      feed.save!
      Member.commented uid
      return feed
  end

  def self.topic(uid,topic_id)
    feed = Feed.new
    feed.member_id = uid
    feed.action = Feed::TOPIC_TYPE
    feed.data = {
        :topic_id => topic_id
    }
    feed.save
    return feed
  end

  def self.comment(uid,comment_id)
    feed = Feed.new
    feed.member_id = uid
    feed.action = Feed::COMMENT_TYPE
    feed.data = {
        :comment_id => comment_id,
    } 
    feed.save
  end

end
