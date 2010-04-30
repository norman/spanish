# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class Sound < Test::Unit::TestCase

  include Linguistics::Phonology

  def setup
    @inventory = SoundInventory.new("a", "b", "f", "p", "t", "z")
  end

  test "should get feature array for symbol" do
    assert_equal [:labial, :stop, :voiced], @inventory["b"].sort,
      @inventory.features("b").sort
  end

  test "& should get symbols matching all features" do
    assert_equal ["b", "f", "p"], @inventory & :labial
    assert_equal ["b", "p"], @inventory & [:labial, :stop]
    assert_equal ["b"], @inventory & [:labial, :stop, :voiced]
  end

  test "| should get symbols matching any features" do
    assert_equal ["a", "b", "z"], @inventory | :voiced
    assert_equal ["a", "b", "f", "p", "z"], @inventory | [:voiced, :labial]
  end

  test "^ should get symbols not matching any features" do
    assert_equal ["f", "p", "t"], @inventory ^ :voiced
    assert_equal ["t"], @inventory ^ [:voiced, :labial]
  end

  test "should get symbol from features" do
    assert @inventory.has? :voiced, :labial, :stop
    assert_equal "b", @inventory.symbol(:voiced, :labial, :stop)
  end

  test "should get features from symbol" do
    assert_equal [:dental, :stop], @inventory["t"].sort
  end

  test "should get mask for symbol" do
    assert_equal 258, @inventory.mask("t")
  end

end
