# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class SyllabificationTest < Test::Unit::TestCase


    CASES = {
      "perro"           => ["pe", "rro"],
      "triple"          => ["tri", "ple"],
      "castro"          => ["cas", "tro"],
      "caldo"           => ["cal", "do"],
      "orden"           => ["or", "den"],
      "él"              => ["él"],
      "fue"             => ["fue"],
      "fuí"             => ["fuí"],
      "feo"             => ["fe", "o"],
      "adjuntar"        => ["ad", "jun", "tar"],
      "gato"            => ["ga", "to"],
      "palo"            => ["pa", "lo"],
      "para"            => ["pa", "ra"],
      "explicar"        => ["ex", "pli", "car"],
      "increíble"       => ["in", "cre", "í", "ble"],
      "estéreo"         => ["es", "té", "re", "o"],
      "estudioso"       => ["es", "tu", "dio", "so"],
      "australiano"     => ["aus", "tra", "lia", "no"],
      "empleado"        => ["em", "ple", "a", "do"],
      "abierto"         => ["a", "bier", "to"],
      "suizo"           => ["sui", "zo"],
      "ingenuo"         => ["in", "ge", "nuo"],
      "policía"         => ["po", "li", "cí", "a"],
      "mayo"            => ["ma", "yo"],
      "malla"           => ["ma", "lla"],
      "láica"           => ["lái", "ca"],
      "atrás"           => ["a", "trás"],
      "reloj"           => ["re", "loj"],
      "haras"           => ["ha", "ras"],
      "bahía"           => ["ba", "hí", "a"],
      "azahar"          => ["a", "za", "har"],
      "ella"            => ["e", "lla"],
      "televisión"      => ["te", "le", "vi", "sión"],
      "posparto"        => ["pos", "par", "to"],
      "subrayar"        => ["sub", "ra", "yar"],
      "desorden"        => ["des", "or", "den"],
      "dieciseis"       => ["die", "ci", "seis"],
      "auxiliar"        => ["au", "xi", "liar"],
      "baile"           => ["bai", "le"],
      "lavándose"       => ["la", "ván", "do", "se"],
      "botnia"          => ["bot", "nia"],
      "ovni"            => ["ov", "ni"],
      "parapsicología"  => ["pa", "rap", "si", "co", "lo", "gi", "a"]
    }

    test "should syllabify basic cases" do
      CASES.each do |given, expected|
        assert_equal expected, Word.new(given).syllables
      end
    end

end
