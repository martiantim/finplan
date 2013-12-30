class User < ActiveRecord::Base
  attr_accessible :name, :born, :profession_id, :gender, :species
  
  belongs_to :profession
  has_many :plans
  has_many :manipulators
  
  GENDERS = [
    ["?", 'U'],
    ["Male", 'M'],
    ["Female", 'F'],
    ["Pet", 'P']
  ]

  PETS = [
    "Cat",
    "Dog"
  ]
  
  def safe_json
    {
      :id => self.id,
      :name => self.name,
      :born => self.born,
      :gender => self.gender,
      :species => self.species,
      :profession => self.profession ? self.profession.name : nil
    }
  end
  
  def age
    (Date.today - self.born)/365
  end
  
  def is_adult?
    age > 18
  end

  def is_pet?
    self.gender == 'P'
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