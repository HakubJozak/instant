require 'net/http'
require "uri"

class Card < ActiveRecord::Base
  has_many :card_choices
  has_many :decks, :through => :card_choices

  def name=(value)
    write_attribute(:name, value)
    self.url ||= "http://www.magiccards.info/query.php?cardname=#{URI.escape(self.name)}"
  end

  def image_url

  end

  def url=(value)
    write_attribute(:url, value)
  end
  
  def image
    self.image = read_attribute(:image) || download_image
  end

  private

    self.url = DeckCheck::get_real_location()


  def download_image
    self.image = Net::HTTP.get(URI.parse(self.image_url))
    save!
    read_attribute(:image)
  end

  def get_image_url(link)
    link = get_real_location(link)
    info_page = Net::HTTP.get(URI.parse(link))

    r = Regexp.new("<img src=\"(/scans/.*)\".*/>")
    info_page.scan(r) do |image_uri|
      return "http://magiccards.info" + image_uri[0]
    end
  end


  private

  def self.get_real_location(link)

    response = Net::HTTP.get_response(URI.parse(link))
    response = Net::HTTP.get_response(URI.parse(response['Location']))
    real_location = "http://magiccards.info" + response['Location']
  end

end
