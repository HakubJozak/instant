class CardsController < ApplicationController
  def show
    @card = if params[:name]
              Card.find_by_name(params[:name])
            else
              Card.find(params[:id])
            end

    respond_to do |format|
      format.html
      format.jpg { render :text => @card.image }
    end
  end

  def detail
  end

end
