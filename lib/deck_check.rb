require 'net/http'
require 'uri'


module DeckCheck

  CARDS_REGEXP = Regexp.new("<p>([0-9])+ <a href=\"(.*)\" onmouse.*>(.*)</a></p>")
  DECK_NAME_REGEXP = Regexp.new(".*<h1>(.*)<span.*</h1>.*")
  IMAGE_REGEXP = Regexp.new("<img src=\".*(/scans/.*\.jpg)\".*")
  CARD_NAME_REGEXP = Regexp.new('<h1><a href=.*>(.*)</a>.*</h1>')



  def self.update_card(card)
    card.url, page = goto_url(card.url)
    #card.name = page.scan(CARD_NAME_REGEXP)[0][0]
    card.image_url = "http://magiccards.info" + page.scan(IMAGE_REGEXP)[0][0]
  end

  def self.update_deck(deck)
    raise "URL not set for deck" unless deck.url

    deck.url, page = goto_url(deck.url)
    deck.name = page.match(DECK_NAME_REGEXP)[1].chop

    page.scan(CARDS_REGEXP) do |count,link, name|
      deck.add_card( count.to_i,  { :name => name, :url => link })
    end
  end

  # TODO - limit number of redirects
  def self.goto_url(url)
    response = Net::HTTP.get_response(URI.parse(url))
    status = response.code.to_i
    
    if status >= 300 and status < 400
      url = response['Location']
      # TODO - put general url beggining instead
      url = "http://magiccards.info" + url unless url.start_with?('http://')
      goto_url(url)
    else
      return url, response.body
    end
  end

  protected

  def self.card_url(name)
    "http://www.magiccards.info/query.php?cardname=#{URI.escape(name)}"
  end

end






