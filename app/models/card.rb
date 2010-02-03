require 'net/http'


class Card < ActiveRecord::Base
  has_many :card_choices
  has_many :decks, :through => :card_choices

  validates_presence_of :name, :url, :image_url
  
  def image
    self.image = read_attribute(:image) || download_image
  end

  private

  def download_image
    self.image = Net::HTTP.get(URI.parse(self.image_url))
    save!
    read_attribute(:image)
  end

end
