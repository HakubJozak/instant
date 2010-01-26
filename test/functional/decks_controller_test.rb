require 'test_helper'

class DecksControllerTest < ActionController::TestCase
  context "DecksController" do
    setup do
      @deck = Factory.attributes_for(:deck)
    end

    should "show creation page" do
      get :new
      assert_response :success
    end

    should "create the deck" do
      post :create, :deck => @deck
      created = assigns(:deck)
      assert_not created.new_record?
      assert_redirected_to deck_url(created.id)
    end

    context "with existing deck" do
      setup { @deck = Factory.create(:deck) }

      should "see the deck" do
        get :show, :id => @deck.id
        assert_response :success
      end

      should "download PDF" do
	get :show, :id => @deck.id, :format => :pdf
        assert_not_nil assigns(:pdf)
        assert_response :success
      end
    end
  end
end
