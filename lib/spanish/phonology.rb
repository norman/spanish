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
      },
      :nasal_assimilation => ::Phonology::Rule.new {
        add :bilabial if nasal? and precedes :bilabial
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
        if syllable_final? and alveolar? and fricative? and follows(:vocoid)
          devoice
          add :glottal
          add! :approximant
        end
      },
      :yeismo => ::Phonology::Rule.new {
        if palatal? and (lateral_approximant? or fricative?)
          add :palatal, :fricative
        end
      },
      :lleismo => ::Phonology::Rule.new {
        add :lateral_approximant if (palatal? and fricative?)
      },
      :zheismo => ::Phonology::Rule.new {
        if palatal? and (lateral_approximant? or fricative?)
          add :postalveolar, :fricative
        end
      },
      :sheismo => ::Phonology::Rule.new {
        if palatal? and (lateral_approximant? or fricative?)
          add :postalveolar, :fricative
          delete :voiced
        end
      }
    }

    def apply_rules(array)
      rules.values.inject(array) {|result, rule| rule.apply(result)}
    end

  end

end
