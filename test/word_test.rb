# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class WordTest < Test::Unit::TestCase

  include Spanish

  test "should detect spanish letters" do
    assert_equal 3, Word.new("qué").letters.length
    assert_equal 3, Word.new("¿qué?").letters.length
    assert_equal 5, Word.new("cañón").letters.length
    assert_equal 2, Word.new("che").letters.length
    assert_equal 4, Word.new("calle").letters.length
  end

end
