require 'test_helper'

class DeckTest < ActiveSupport::TestCase
  context "Deck" do
    setup do
      @deck = Factory.create(:deck)
    end

    should "not be ready when created" do
      assert_not @deck.ready?
    end

    should "add cards on the list when asked to be prepared!" do
      cards = [ "Maelstrom Pulse", "Dragonskull Summit", "Forest" ]

      [ "\n", "\n\r", "\r\n" ].each_with_index do |separator,i| 
        deck = Deck.create(:name => 'dummy', :cards_list => cards.join(separator))
        deck.prepare!
        
        assert_equal true, deck.ready?
        assert_equal deck.cards.size, 3, "Separator #{separator} failed"
      end
    end

  end


  should "download all cards (without images) before save" do
    deck = Factory.create(:deck)
    deck.prepare!
    assert_equal 26, deck.cards.size
    assert_equal 75, deck.cards_amount 
  end


end
