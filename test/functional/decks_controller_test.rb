require 'test_helper'

class DecksControllerTest < ActionController::TestCase
  context "DecksController" do
    setup do
      @cards = [ "Maelstrom Pulse", "Dragonskull Summit", "Forest" ].join("\n")
    end

    should "show creation page" do
      get :new
      assert_response :success
    end

    should "create the deck from url" do
      post :create, :deck => Factory.attributes_for(:deck)
      created = assigns(:deck)
      assert_not created.new_record?
      assert_redirected_to deck_url(created)
    end

    should "create the deck from card list" do
      post :create, :deck => { :name => 'Some name' }, :cards => @cards
      deck = assigns(:deck)
      assert_not deck.ready?
      assert_redirected_to :action => :show, :controller => :decks, :id => deck.id
    end

    context "with existing deck" do
      setup { @deck = Factory.create(:deck) }

      should "see the deck" do
        get :show, :id => @deck.id
        assert_response :success
      end

      context "with many cards" do
        setup do
          10.times { @deck.card_choices.create( :card => Factory.create(:card), :count => 2 ) }
        end

        should "show list page" do
          get :index
          assert_response :success
        end

        should "show card table" do
          get :show, :id => @deck.id
          assert_response :success
          assert_select "table#cards" do
            assert_select "td.card", 10
          end
        end
      end

    end
  end
end
