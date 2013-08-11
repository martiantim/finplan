class User < ActiveRecord::Base
  attr_accessible :name, :born
  
  has_many :plans
  has_many :manipulators
  
  def safe_json
    {
      :name => self.name,
      :born => self.born
    }
  end
  
  def age
    (Date.today - self.born)/365
  end
  
  def is_adult?
    age > 18
  end
  
  def born?
    age > 0
  end
  
  def self.ages_for_select(range)
    range.to_a.collect do |a|
      disp = a
      disp = "in #{a*-1} years" if a < 0
      
      [disp, "#{Date.today.year-a}-01-01"]
    end
  end
  
end