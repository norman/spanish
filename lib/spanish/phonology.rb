# encoding: utf-8
module Spanish

  module Phonology

    extend self

    attr_reader :rules

    @rules = {
      :sprinantization => ::Phonology::Rule.new {
        if voiced? and plosive? and !initial? and precedes(:vocoid) and !follows(:nasal)
          if non_coronal?
            add :fricative
          elsif coronal? and !follows(:lateral_approximant)
            add :fricative, :dental
          end
        end
      },
      :seseo => ::Phonology::Rule.new {
        add :alveolar if dental? and unvoiced?
      },
      :voicing => ::Phonology::Rule.new {
        voice if alveolar? and fricative? and precedes(:voiced, :non_vocoid)
      }
    }

    def apply_rules(array)
      rules.values.inject(array) {|result, rule| rule.apply(result)}
    end

  end

end
