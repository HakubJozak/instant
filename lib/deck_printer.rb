require 'prawn/measurement_extensions'
require "stringio" 


class DeckPrinter

  CARD_W = 63.mm
  CARD_H = 88.mm
  PADDING = 0.3

  OPTIONS = {
      :page_layout => :portrait,
      :left_margin => 5.mm,
      :right_margin => 5.mm,
      :top_margin => 5.mm,
      :bottom_margin => 5.mm,
    }

  def initialize(options = {})
    @columns = options[:columns]
    @rows = options[:rows]
    @page_size = options[:page_size] || 'A4'
    @page_layout = options[:page_layout] || :portrait
  end

  def print(deck)
    custom = { :page_size => @page_size, :page_layout => @page_layout }

    deck_pdf = Prawn::Document.new(OPTIONS.merge(custom)) do |pdf|
      deck.cards.each_slice(@rows * @columns).each do |page|
        page.each_slice(@columns).each_with_index do |cards_in_row, row|
          cards_in_row.each_with_index do |card, column|
            puts "row: #{row}"
            puts "column: #{column}"
            coordinates = [ column * (CARD_W + PADDING.mm), pdf.bounds.top - row * (CARD_H + PADDING.mm)]
            pdf.image StringIO.new(card.image), :width => CARD_W, :height => CARD_H, :at => coordinates
          end
        end

        pdf.start_new_page
      end
    end

    deck_pdf.render
  end
end
