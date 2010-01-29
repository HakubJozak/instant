class AddImageUrl < ActiveRecord::Migration
  def self.up
    add_column :cards, :image_url, :string, :limit => 2048
  end

  def self.down
    remove_column :cards, :image_url
  end
end
