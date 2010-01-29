class DecksController < ApplicationController

  def new
    @deck = Deck.new #(:url => "http://www.deckcheck.net/deck.php?id=31736")
  end

  def create
    if (params[:deck])
      @deck = Deck.new(params[:deck])

      if @deck.save
        flash[:info] = 'Deck succesfully created'
        redirect_to :action => :show, :id => @deck
      else
        redirect_to :action => :new
      end
    else
      @deck = Deck.create_from_cardslist(params[:cards])
      redirect_to :action => :show, :id => @deck.id
    end

  end

  def show
    @deck = Deck.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do 
        @pdf = DeckPrinter.print(@deck)
        send_data( @pdf, :filename => "deck.pdf") 
      end
    end
  end
end
