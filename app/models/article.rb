class Article < ActiveRecord::Base
  # validating the articles, ensure that there is a title, description otherwise does not save
  validates :title, presence: true, length: {minimum: 3, maximum: 50 }
  validates :description, presence: true, length: {minimum: 10, maximum: 300 }
  # creates the relationship between Article and Author models. It basically says a article belongs to the author, and a author can have many articles. This is known as a one-to-many relationship.
  belongs_to :author

  def slug
    self.title.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slug)
    self.all.find { |i| i.slug == slug }
  end
end