require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  context "CardsController" do
    setup do
      @card = Factory.create(:card)
    end
    
    should "should show card by name or id" do
      [ {:id => @card.id} , { :name => @card.name } ].each do |params|
        get :show, params
        assert_not_nil assigns(:card), "No card found"
        assert_response :success
      end
    end

  end
end
