class Profile < ActiveRecord::Base
  attr_accessible :member_id, :sense
  belongs_to :member
  
  

  def incr(num)
    self.sense += num
    Feed.sense self.member.id,num
    self.save
  end

  def decr(num)
    if self.sense < num
      raise "no sense"
    else 
      self.sense -= num
      self.save
    end
  end
end
