class CreateCardChoices < ActiveRecord::Migration
  def self.up
    create_table :card_choices do |t|
      t.integer :card_id
      t.integer :deck_id
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :card_choices
  end
end
