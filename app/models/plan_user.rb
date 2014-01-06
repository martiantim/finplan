class PlanUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan


  
  def is_adult?
    user.is_adult?
  end
  
end