class DecksController < ApplicationController

  def new
  end

  def create
    if (params[:url])
      create_by_url(params[:url])
    elsif not params[:cards].empty?
      @deck = Deck.create_from_cardslist(params[:cards])
      redirect_to :action => :show, :id => @deck.id
    end

  rescue => e
    Rails.logger.error("Failed to create deck information: #{e}")
    flash[:error] = "Failed to create deck"
    redirect_to :action => :new
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

  protected

  def create_by_url(url)
    @deck = Deck.new(:url => url)
    @deck = DeckCheck.download_deck(url)

    if @deck.save
      flash[:info] = 'Deck succesfully created'
      redirect_to :action => :show, :id => @deck
    else
      redirect_to :action => :new
    end
  end
end
