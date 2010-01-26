class CardChoice < ActiveRecord::Base
  validates_presence_of :count
  validates_presence_of :card
  validates_presence_of :deck

  belongs_to :card
  belongs_to :deck
end
