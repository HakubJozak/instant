require 'test_helper'

class CardTest < ActiveSupport::TestCase
  context "Card" do
    should "supply a valid image" do
      c = Card.create(:name => "Martyr of Sands")
      assert_not_nil c.image
      assert_not_nil c.name
      assert_not_nil c.url
    end
  end
end