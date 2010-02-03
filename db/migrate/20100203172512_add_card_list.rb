class AddCardList < ActiveRecord::Migration
  def self.up
    add_column :decks, :cards_list, :text
  end

  def self.down
    remove_columns :decks, :cards_list
  end
end
