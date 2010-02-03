class DecksController < ApplicationController

  def new
    @deck = Deck.new(:name => "Hand-made deck", :url => 'http://www.deckcheck.net/deck.php?id=32102')
  end

  def create
    @deck = Deck.new(params[:deck])

    if @deck.save
      flash[:info] = 'Deck succesfully created'
      #Delayed::Job.enqueue DownloadDeckJob.new(self.id)
      redirect_to deck_url(@deck)
    else
      render :action => "new"
    end
    
  rescue => e
    Rails.logger.error("Failed to create deck: #{e}")
    flash[:error] = "Failed to create deck #{e}"
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

  # TODO - remove this
  def refresh
    @deck = Deck.find(params[:id])
    @deck.prepare!
    redirect_to url_for(@deck)
  end


end
