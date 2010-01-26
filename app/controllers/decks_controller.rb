class DecksController < ApplicationController

  def new
    @deck = Deck.new(:url => "http://www.deckcheck.net/deck.php?id=31736")
  end

  def create
    @deck = Deck.new(params[:deck])

    if @deck.save
      flash[:info] = 'Deck succesfully created'
      redirect_to :action => :show, :id => @deck
    else
      redirect_to :action => :new
    end
  end

  def show
    @deck = Deck.find(params[:id])
    @pdf = DeckPrinter.print(@deck)

    respond_to do |format|
      format.html
      format.pdf { send_data( @pdf, :filename => "deck.pdf") }
    end
  end
end
