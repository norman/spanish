# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class SyllabificationTest < Test::Unit::TestCase


    CASES = {
      "gato"      => ["ga", "to"],
      "perro"     => ["pe", "rro"],
      "increíble" => ["in", "cre", "í", "ble"],
      "explicar"  => ["ex", "pli", "car"]
    }

    test "should syllabify basic cases" do
      CASES.each do |given, expected|
        assert_equal expected, Word.new(given).syllables
      end
    end

end
