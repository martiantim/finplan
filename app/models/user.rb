class User < ActiveRecord::Base
  attr_accessible :name
  
  has_many :plans
  has_many :manipulators
  
  def safe_json
    {
      :name => self.name,
      :born => self.born
    }
  end
  
end