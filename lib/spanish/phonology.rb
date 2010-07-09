# encoding: utf-8
module Spanish

  module Phonology

    extend self

    attr_reader :general_rules
    attr_reader :optional_rules

    @general_rules = {
      :sprinantization => ::Phonology::Rule.new {
        if voiced? and plosive? and !initial? and precedes(:vocoid) and !follows(:nasal)
          if non_coronal?
            add :fricative
          elsif coronal? and !follows(:lateral_approximant)
            add :fricative, :dental
          end
        end
      }
    }
    @optional_rules = {
      :seseo => ::Phonology::Rule.new {
        add :alveolar if dental? and unvoiced?
      },
      :voicing => ::Phonology::Rule.new {
        voice if alveolar? and fricative? and precedes(:voiced, :non_vocoid)
      },
      :aspiration => ::Phonology::Rule.new {
        if alveolar? and fricative? and follows(:vocoid) and syllable_final?
          add! :approximant
          add! :fricative
          add :glottal
          delete :voiced
        end
      },
      :yeismo => ::Phonology::Rule.new {
        if lateral_approximant?
          add :palatal
          add :fricative
        end
      },
      :lleismo => ::Phonology::Rule.new {
        if palatal? and fricative?
          add :lateral_approximant
        end
      },
      :zheismo => ::Phonology::Rule.new {
        if palatal? and (lateral_approximant? or fricative?)
          add :postalveolar
          add :fricative
        end
      },
      :sheismo => ::Phonology::Rule.new {
        if palatal? and (lateral_approximant? or fricative?)
          add :postalveolar
          add :fricative
          delete :voiced
        end
      },

    }

    def apply_rules(array)
      rules.values.inject(array) {|result, rule| rule.apply(result)}
    end

  end

end
