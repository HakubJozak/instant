module CardsHelper

  # Render cards in a table, 3 cards in each row
  def card_rows(cards, &block)
    rows = cards.size / 3
    rows += 1 if cards.size % 3 > 0

    rows.times do |row|
      text = content_tag :tr do
        one_row = ""

	3.times do |col|
          i = row * 3 + col

          td = if i < cards.size
                 content_tag_for(:td, cards[i]) { yield(cards[i]) }
               else
                 content_tag(:td)
               end
          
          one_row.concat(td)
        end

        one_row
      end

      concat(text)
    end
  end
end
