
require 'uuidtools' 

class Invitation < ActiveRecord::Base
  attr_accessible :invite_code, :inviter_id, :member_id
  belongs_to :member
  belongs_to :inviter,:class_name => "Member"

  MAX_SIZE = 1000
  MEMBER_SIZE = 30
  COST = 1

  def self.generate member
    if Invitation.all.size < Invitation::MAX_SIZE and member.invitations.size < Invitation::MEMBER_SIZE
      profile =  Profile.find_or_create_by_member_id member.id
      if profile.sense < Invitation::COST
        return
      end
      profile.decr Invitation::COST
      invitation = Invitation.new
      invitation.member = member
      invitation.invite_code = UUIDTools::UUID.random_create.to_s.gsub('-','')
      invitation.save
      return invitation
    end
  end

  def self.generate_no_limit member
    invitation = Invitation.new
    invitation.member = member
    invitation.invite_code = UUIDTools::UUID.random_create.to_s.gsub('-','')
    invitation.save
    return invitation
  end
end
