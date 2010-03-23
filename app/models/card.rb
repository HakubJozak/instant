require 'net/http'


class Card < ActiveRecord::Base
  has_many :card_choices
  has_many :decks, :through => :card_choices

  validates_presence_of :name, :url

  def before_validation_on_create
    self.url ||= DeckCheck.card_url(self.name)
  end

  def self.find_or_create_by_name(name)
    unless card = find_by_name(name)
      card = create!(:name => name)
      DeckCheck.update_card(card)
      card.save
    end
    
    card
  end

  def image_url
    unless read_attribute(:image_url)
      DeckCheck.update_card(self)
      save
    end

    read_attribute(:image_url)
  end
  
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
