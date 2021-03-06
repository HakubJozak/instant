class Deck < ActiveRecord::Base

  class NotReady < StandardError 
  end

  DECK_CHECK_FORMAT = /http:\/\/www.deckcheck.net\/deck.php\?id=[0-9]+/

  has_many :card_choices
  has_many :cards, :through => :card_choices

  validates_format_of :url, :with => DECK_CHECK_FORMAT, :if => Proc.new { |d| not d.url.blank? }
  validate :must_be_either_cards_or_url
  
  def must_be_either_cards_or_url
    errors.add_to_base("Specify either name and card list or URL to create a deck.") if name.blank? and url.blank?
  end
  
  def ready?
    self.ready > 0
  end

  def cards_amount
    raise NotReady unless ready
    card_choices.reduce(0) { |sum, choice| sum += choice.count }
  end

  def add_card(count, params)
    card = Card.find_or_create_by_name(params[:name])
    self.card_choices.create(:count => count, :card => card)
  end

  # If the URL is set, then it downloads the list of cards, creates/finds them and associates with the deck.
  # If the cards list is specified, it does the same with tha cards on the list.
  # Sets the status flag accordingly.
  def prepare!
    self.card_choices.delete_all

    if self.url
      DeckCheck.update_deck(self)
    elsif self.cards_list
      add_cards_by_list
    else
      raise "Neither URL nor cards list set on deck"
    end

    self.ready = 1
    save!
  end

  private

  def add_cards_by_list
    cards_list.lines do |card_name|
      begin
        card = Card.find_or_create_by_name(card_name.strip) 
        card_choices.create(:card => card, :count =>1 )
      rescue
        errors.add_to_base("Card '#{name}' not found")
      end
    end    
  end

  def self.find_or_create_by_name(name)
    unless card = find_by_name(name)
      card = Card.create(:name => name)
      DeckCheck.update_card(card)
    end

    card
  end

end
