class DownloadDeckJob < Struct.new(:deck_id, :card_names)

  def perform
    deck = Deck.find(deck_id)
    puts deck.name
  end   

  # def create_from_card_names(card_names)
  #   list.lines do |name|
  #     card = Card.find_or_create_by_name(name.strip)
  #     deck.card_choices.create(:card => card, :count =>1 )
  #   end

  #   deck
  # end

end
