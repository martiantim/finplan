class User < ActiveRecord::Base
  attr_accessible :name
  
  has_many :plans
  has_many :manipulators
  
end