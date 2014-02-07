class User < ActiveRecord::Base

  belongs_to :profession
  has_many :plans
  has_many :manipulators

  scope :adults, :conditions => "DATE(NOW()) - DATE(born) > #{365*18}"

  validates :email, length: { minimum: 2 }
  validates :name, length: { minimum: 2 }
  validate :check_password

  def check_password
    return if !@new_password

    if @new_password.length < 6
      errors.add(:password, "Password too short")
      return
    end
  end

  def password= (pass)
    @new_password = pass
    self.salt = ""
    15.times { self.salt += (Random.rand*26+64).to_i.chr }

    self.password_encrypted =  Digest::MD5.hexdigest(self.salt + ":" + pass)
  end

  def password_match?(pass)
    self.password_encrypted == Digest::MD5.hexdigest(self.salt + ":" + pass)
  end

  def set_auth_token
    self.auth_token = ""
    35.times { self.auth_token += (Random.rand*26+64).to_i.chr }
  end

  def role
    if gender == 'F'
      'woman'
    else
      'man'
    end
  end
end
