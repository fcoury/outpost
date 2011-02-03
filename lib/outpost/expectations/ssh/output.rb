module Outpost
  module Expectations::Ssh
    module Output
      def self.extended(base)
        base.expect :output, base.method(:evaluate_output)
      end
      
      def evaluate_output(scout, rules)
        deferred_evaluations = []
        
        success = rules.all? do |rule, comparison|
          case rule
          when :match
            if scout.output =~ comparison
              @capture = $1
            end
          when :less_than
            deferred_evaluations << lambda { 
              @capture.to_f < comparison
            }
          end
        end
        
        success && deferred_evaluations.all?(&:call)
      end      
    end
  end
end