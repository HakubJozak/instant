require "uri"

class Card < ActiveRecord::Base
  has_many :card_choices
  has_many :decks, :through => :card_choices

  def before_create
    self.url ||= DeckCheck::get_real_location("http://www.magiccards.info/query.php?cardname=#{URI.escape(self.name)}")
    self.image_url ||= DeckCheck.get_image_url(self.url)
  end
  
  def image
    self.image = read_attribute(:image) || download_image
  # rescue => e
  #   logger.warn "Failed to find image tag in #{link}: #{e}"
  #   nil
  end

  private

  def download_image
    self.image = DeckCheck::download_image(self.image_url)
    save!
    read_attribute(:image)
  rescue => e
    logger.warn "Failed to download image #{image_url}: #{e}"
    nil
  end
end
