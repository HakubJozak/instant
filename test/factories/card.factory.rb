Factory.define :card do |c|
  c.name "Armament Master"
  c.url  "http://magiccards.info/zen/en/1.html"
  c.image File.new("#{RAILS_ROOT}/test/data/1.jpg").read
end
