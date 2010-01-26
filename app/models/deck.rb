class Deck < ActiveRecord::Base
  DECK_CHECK_FORMAT = /http:\/\/www.deckcheck.net\/deck.php\?id=[0-9]+/

  has_many :card_choices
  has_many :cards, :through => :card_choices
  validates_format_of :url, :with => DECK_CHECK_FORMAT

  def after_create
    DeckCheck.download_deck(self)
  end

  def cards_amount
    card_choices.reduce(0) { |sum, choice| sum += choice.count }
  end

  def add_card(count, params)
    card = Card.find_by_name(params[:name]) || Card.new(params)
    self.card_choices.create(:count => count, :card => card)
  end

end
