require 'test_helper'

class DeckCheckTest < ActiveSupport::TestCase
  context "While online" do
    setup do
      FakeWeb.allow_net_connect = true
      FakeWeb.clean_registry
    end

    should "automatically redirect until the end" do
      url, body = DeckCheck.goto_url('http://www.magiccards.info/query.php?cardname=Oran-Rief%2C+the+Vastwood')
      assert_equal 'http://magiccards.info/zen/en/221.html', url
    end

    should "return original URL when no redirect needed" do
      stable = 'http://www.wikipedia.org'
      url, body = DeckCheck.goto_url(stable)
      assert_equal stable, url
    end

    should "download card by name and url" do
      card = DeckCheck.download_card_by_name('Martyr of Sands')
      assert_equal_cards Factory.build(:martyr_of_sands), card
    end

    should "download card by url" do
      card = DeckCheck.download_card_by_url( 'http://www.magiccards.info/query.php?cardname=Martyr%20of%20Sands')
      assert_equal_cards Factory.build(:martyr_of_sands), card
    end
  end

  private 
  
  def assert_equal_cards(c1, c2)
    [ :name, :url, :image_url ].each do |attr|
      assert_equal c1.send(attr), c2.send(attr)
    end
  end

end
