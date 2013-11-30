class PlanUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  scope :sorted_backwards, :joins => :assessment, :order => "assessments.end_date DESC"
  scope :adults, :joins => :user, :conditions => "DATE(NOW()) - DATE(born) > #{365*18}"
  
  def family_role
    if user.is_pet?
      if user.species == 'cat'
        "cat"
      elsif user.species == 'dog'
        "dog"
      else
        "unsure"
      end
    elsif is_adult?
      if user.gender == 'M'
        "man"
      elsif user.gender == 'F'
        "woman"
      else
        "unsure"
      end
    elsif user.born?
      if user.gender == 'M'
        "boy"
      elsif user.gender == 'F'
        "girl"
      else
        "unsure"
      end
    else
      "baby"
    end
      
  end
  
  def is_adult?
    user.is_adult?
  end
  
end