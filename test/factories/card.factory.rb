Factory.define :card do |c|
  c.sequence(:name) { |n| "Martyr of Sands#{name}" }
  c.url  'http://magiccards.info/cs/en/15.html'
  c.image_url 'http://magiccards.info/scans/en/cs/15.jpg'
end

Factory.define :martyr_of_sands, :parent => :card do |c|
end
