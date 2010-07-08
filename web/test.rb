require File.expand_path('../spanish.rb', __FILE__)
require 'test/unit'
require 'rack/test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get "/"
    assert_equal 200, last_response.status
  end

  def test_ipa
    get "/ipa/hola"
    assert_equal 200, last_response.status
  end

  def test_api_ipa
    get "/api/ipa/hola"
    assert_equal 200, last_response.status
  end


end
