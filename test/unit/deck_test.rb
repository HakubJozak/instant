require 'test_helper'

class DeckTest < ActiveSupport::TestCase
  
  should "validate DeckCheck URLs" do
    assert_valid Factory.build(:deck)
  end

  should "create deck from cards list" do
    cards = [ "Maelstrom Pulse", "Dragonskull Summit", "Forest" ]

    [ "\n", "\n\r", "\r\n" ].each do |separator| 
      d = Deck.create_from_cardslist(cards.join(separator))
      assert_equal d.cards.size, 3, "Separator #{separator} failed"
    end
  end

  should "download all cards (without images) before save" do
    deck = Factory.create(:deck)
    assert_equal 26, deck.cards.count
    assert_equal 75, deck.cards_amount 
  end

end
