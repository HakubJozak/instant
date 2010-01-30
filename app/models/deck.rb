class Deck < ActiveRecord::Base
  DECK_CHECK_FORMAT = /http:\/\/www.deckcheck.net\/deck.php\?id=[0-9]+/

  has_many :card_choices
  has_many :cards, :through => :card_choices
  validates_format_of :url, :with => DECK_CHECK_FORMAT, :if => :url

  def self.create_from_cardslist(list = "")
    deck = Deck.new(:name => "Hand-made deck")
    deck.save!

    list.lines do |name|
      card = Card.find_or_create_by_name(name.strip)
      deck.card_choices.create(:card => card, :count =>1 )
    end

    deck
  end

  def after_create
    DeckCheck.download_deck(self) if self.url
  end

  def cards_amount
    card_choices.reduce(0) { |sum, choice| sum += choice.count }
  end

  def add_card(count, params)
    card = Card.find_by_name(params[:name]) || Card.create(params)
    self.card_choices.create(:count => count, :card => card)
  end

end
