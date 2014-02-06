class PlanUser < ActiveRecord::Base
  belongs_to :plan
  belongs_to :profession

  scope :adults, -> { where("DATE(NOW()) - DATE(born) > #{365*18}") }


  GENDERS = [
      ["?", 'U'],
      ["Male", 'M'],
      ["Female", 'F']
  ]

  def safe_json
    {
        :id => self.id,
        :name => self.name,
        :born => self.born,
        :gender => self.gender,
        :profession => self.profession ? self.profession.name : nil
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

  def family_role
    if is_adult?
      if self.gender == 'M'
        "man"
      elsif self.gender == 'F'
        "woman"
      else
        "unsure"
      end
    elsif self.born?
      if self.gender == 'M'
        "boy"
      elsif self.gender == 'F'
        "girl"
      else
        "unsure"
      end
    else
      "baby"
    end

  end

  def self.ages_for_select(range)
    range.to_a.collect do |a|
      disp = a
      disp = "in #{a*-1} years" if a < 0

      [disp, "#{Date.today.year-a+1}-01-01"]
    end
  end

end