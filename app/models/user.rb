class User < ActiveRecord::Base

  belongs_to :profession
  has_many :plans
  has_many :manipulators

  scope :adults, :conditions => "DATE(NOW()) - DATE(born) > #{365*18}"

end
