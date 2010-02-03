class AddDjToDeck < ActiveRecord::Migration
  def self.up
    add_column :decks, :delayed_job_id, :integer
    add_column :decks, :ready, :integer, :default => 0
  end

  def self.down
    remove_columns :decks, :delayed_job_id
    remove_columns :decks, :ready
  end
end
