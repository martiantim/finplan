class PlanUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  scope :adults, :joins => [:user], :conditions => "DATE(NOW()) - DATE(users.born) > #{365*18}"

  def is_adult?
    user.is_adult?
  end

  def family_role
    user.family_role
  end
  
end