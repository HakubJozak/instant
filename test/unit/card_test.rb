require 'test_helper'

class CardTest < ActiveSupport::TestCase
  context "Card" do
    should "supply a valid image" do
      c = Card.new(:name => "Martyr of Sands")
      assert_valid c
      assert_not_nil c.name
      assert_not_nil c.url
      assert_not_nil c.image_url
    end
  end
end
