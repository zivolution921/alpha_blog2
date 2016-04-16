class Author < ActiveRecord::Base
  has_many :articles

  validates_presence_of :username, :email, :password
  has_secure_password
  
  def slug
    self.username.downcase.split(" ").join("-")
  end
  
  def self.find_by_slug(slug)
    self.all.find { |i| i.slug == slug}
  end
end