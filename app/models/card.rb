require "uri"

class Card < ActiveRecord::Base
  has_many :card_choices
  has_many :decks, :through => :card_choices

  def before_create
    self.url ||= "http://www.magiccards.info/query.php?cardname=#{URI.escape(self.name)}"
  end

  def image
    self.image = read_attribute(:image) || download_image
  end

  private

  def download_image
    self.image = DeckCheck.download_image(self.url)
    save!
    read_attribute(:image)
  end
end