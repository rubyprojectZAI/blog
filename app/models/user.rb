require 'digest/sha1'
class User < ActiveRecord::Base
	has_many :posts
	validates_presence_of :login, :password
  # attr_accessor :hashed_password
	
	# validates_length_of :password, :within => 8..25, :on => :create
	
	before_save :create_hashed_password
	after_save :clear_password
	
	# attr_protected  :password, :salt
	
	def self.authenticate(login="", password="")
	  user = User.find_by_login(login)
	  if user && user.password == User.hash_with_salt(password, User.make_salt(login))
	    return user
	  else
	    return false
	  end
	  # return user
	end
	
	def password_match?(hashed_password="")
	  password == User.hash_with_salt(hashed_password, salt)
	end
	
	def self.make_salt(login="")
	  # Digest::SHA1.hexdigest("Use #{login} with #{Time.now} to make salt")
	  Digest::SHA1.hexdigest("Use #{login} to make salt")
	end

  def self.hash_with_salt(password="", salt="")
    Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end
  
  private
 
  def create_hashed_password
    unless password.blank?
      self.salt = User.make_salt(login) if salt.blank?
      self.password = User.hash_with_salt(password, salt)
    end
  end
  
  def clear_password
    self.password= nil
  end

end
