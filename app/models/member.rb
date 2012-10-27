#coding:utf-8
class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username,:email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body


  validates :username,:uniqueness => {:message => "用户名重复" },:format => { :with => $USERNAME_REGEX,:message => "包含错误字符" },:length => { :in => 1..40 }
  validates :password,:length => { :in => 6..40 }

  has_many :invitations
  has_many :topics
  has_one  :profile

  acts_as_tagger


  def self.unread(id)
    key = "members:#{id}:unread"
    unread = $redis.get key
    unread = 0 unless unread
    unread
  end

  def self.mention(id)
    key = "members:#{id}:mention"
    $redis.incr key
  end

  def self.sense(id,num)
    key = "members:sense"
    $redis.zincrby key,num,id
  end

  def self.get_sense(id)
    key = "members:sense"
    sense = $redis.zscore key,id
    sense = 0 unless sense
    sense.to_i
  end

  def self.clear_sense(id)
    key = "members:sense"
    $redis.zrem key,id
  end

  def self.commented(id)
    key = "members:#{id}:commented"
    $redis.incr key
  end
  
  def self.praise(id)
    key = "members:#{id}:praise"
    $redis.incr key
  end

  def self.get_praise(id)
    key = "members:#{id}:praise"
    praises = $redis.get key
    praises = 0 unless praises
    praises.to_i
  end

  def self.get_commented(id)
    key = "members:#{id}:commented"
    commented = $redis.get key
    commented =0 unless commented
    commented.to_i
  end


  def self.get_mention(id)
    key = "members:#{id}:mention"
    mention = $redis.get key
    mention = 0 unless mention
    mention.to_i
  end 





  def self.clear_mention(id)
    key = "members:#{id}:mention"
    $redis.del key
  end

  def self.clear_commented(id)
    key = "members:#{id}:commented"
    $redis.del key
  end

  def self.clear_praise(id)
    key = "members:#{id}:praise"
    $redis.del key
  end



  def self.pv(id)
    key = "members:pv:count"
    $redis.zincrby key,1,id
    key = "total:pv"
    $redis.incr key
  end

  def self.get_total_pv
    key = "total:pv"
    pv = $redis.get key
    pv = 0 unless pv
    pv.to_i
  end

  def self.get_pv(id)
    key = "topics:pv:count"
    pv = $redis.zscore key,id
    pv = 0 unless pv
    pv.to_i
  end




end
