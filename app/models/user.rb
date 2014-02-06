class User < ActiveRecord::Base

  belongs_to :profession
  has_many :plans
  has_many :manipulators

  scope :adults, :conditions => "DATE(NOW()) - DATE(born) > #{365*18}"

  def password= (pass)
    self.salt = ""
    15.times { self.salt += (Random.rand*26+64).to_i.chr }

    self.password_encrypted =  Digest::MD5.hexdigest(self.salt + ":" + pass)
  end

  def password_match?(pass)
    self.password_encrypted == Digest::MD5.hexdigest(self.salt + ":" + pass)
  end

  def set_auth_token
    self.auth_token = 35.times { self.salt += (Random.rand*26+64).to_i.chr }
  end
end
