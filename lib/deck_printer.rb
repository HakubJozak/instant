require 'prawn/measurement_extensions'
require "stringio" 


module DeckPrinter

  CARD_W = 63.mm
  CARD_H = 88.mm

  OPTIONS = {
      :page_layout => :portrait,
      :left_margin => 5.mm,
      :right_margin => 5.mm,
      :top_margin => 5.mm,
      :bottom_margin => 5.mm,
      :page_size => 'A4'
    }

  def self.print(deck)
    deck_pdf = Prawn::Document.new(OPTIONS) do |pdf|
      @count = 0

      deck.cards.each do |card|
        column = @count % 3
        row = @count / 3
        @count = (@count + 1) % 9
        coordinates = [ column * (CARD_W + 5.mm), pdf.bounds.top - row * (CARD_H + 5.mm)]
        pdf.image StringIO.new(card.image), :width => CARD_W, :height => CARD_H, :at => coordinates
        pdf.start_new_page if @count == 0
      end
    end

    deck_pdf.render
  end
end
