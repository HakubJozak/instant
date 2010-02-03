require 'test_helper'

class CardTest < ActiveSupport::TestCase
  context "Card" do
    setup { CardTest.subject { Factory.create(:card) }}

    should_validate_presence_of :name, :url, :image_url
  end
end
