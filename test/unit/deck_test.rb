require 'test_helper'

class DeckTest < ActiveSupport::TestCase
  
  should "validate DeckCheck URLs" do
    assert_valid Factory.build(:deck)
  end

  should "download all cards (without images) before save" do
    deck = Factory.create(:deck)
    assert_equal 26, deck.cards.count
    assert_equal 75, deck.cards_amount 
  end

end
