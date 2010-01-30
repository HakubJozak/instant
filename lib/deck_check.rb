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

end



