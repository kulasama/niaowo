class Tag < ActiveRecord::Base
  validates :name,:length => { :in => 1..16 }
  has_many :taggings
end