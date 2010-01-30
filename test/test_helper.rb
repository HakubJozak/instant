ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'fakeweb'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def assert_not(what, message = "should not be true")
    assert !what, message
  end

  root = "#{RAILS_ROOT}/test/data"
  FakeWeb.register_uri(:get, %r|http://www\.deckcheck\.net/deck\.php\?id=[0-9]*|, 
                       :body => File.new("#{root}/jund.html").read )

  FakeWeb.register_uri(:get, %r|http://www\.magiccards\.info/query\.php\?cardname=.*|, 
                       :response => File.new("#{root}/card_1").read )

  FakeWeb.register_uri(:get, %r|http://magiccards\.info/query\.php\?cardname=.*|, 
                       :response => File.new("#{root}/card_2").read )

  FakeWeb.register_uri(:get, %r|http://magiccards\.info/.*/en/.*\.html|, 
                       :body => File.new("#{root}/card_3.html").read)

  FakeWeb.register_uri(:get, %r|http://magiccards\.info/scans/.*\.jpg|, 
                       :body => File.new("#{root}/card.jpg").read)

  FakeWeb.allow_net_connect = false
end
