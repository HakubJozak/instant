require 'net/http'
require 'uri'


module DeckCheck

  CARDS_REGEXP = Regexp.new("<p>([0-9])+ <a href=\"(.*)\" onmouse.*>(.*)</a></p>")
  NAME_REGEXP = Regexp.new(".*<h1>(.*)<span.*</h1>.*")

  def self.download_deck(deck)
    page = Net::HTTP.get(URI.parse(deck.url))
    deck.name = page.match(NAME_REGEXP)[1].chop
   
    page.scan(CARDS_REGEXP) do |count,link, name|
      deck.add_card( count.to_i,  { :name => name, :url => link })
    end
  end

  def self.get_image_url(link)
    info_page = Net::HTTP.get(URI.parse(link))

    r = Regexp.new("<img src=\"(/scans/.*)\".*/>")
    info_page.scan(r) do |image_uri|
      return "http://magiccards.info" + image_uri[0]
    end
  end

  def self.download_image(link)
    Net::HTTP.get(URI.parse(link))
  end


  private

  def self.get_real_location(link)
    response = Net::HTTP.get_response(URI.parse(link))
    response = Net::HTTP.get_response(URI.parse(response['Location']))
    real_location = "http://magiccards.info" + response['Location']
  end


end



