class PlanUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  scope :sorted_backwards, :joins => :assessment, :order => "assessments.end_date DESC"
  scope :adults, :joins => :user, :conditions => "DATE(NOW()) - DATE(born) > #{365*18}"
  
end