require 'test_helper'

class DeckPrinterTest < ActiveSupport::TestCase
  context "With 20 cards" do
    setup do
      20.times { Factory.create(:card) }
    end
  end
end
