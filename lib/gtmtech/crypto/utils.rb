require 'fileutils'
require 'bigdecimal'

module Gtmtech
  module Crypto
    class Utils

      def self.camelcase string
        return string if string !~ /_/ && string =~ /[A-Z]+.*/
        string.split('_').map{|e| e.capitalize}.join
      end

      def self.snakecase string
        return string if string !~ /[A-Z]/
        string.split(/(?=[A-Z])/).collect {|x| x.downcase}.join("_")
      end

      def self.find_closest_class args
        parent_class = args[ :parent_class ]
        class_name = args[ :class_name ]
        constants = parent_class.constants
        candidates = []
        constants.each do | candidate |
          candidates << candidate.to_s if candidate.to_s.downcase == class_name.downcase
        end
        if candidates.count > 0
          parent_class.const_get candidates.first
        else
          nil
        end
      end

      def self.require_dir classdir
        num_class_hierarchy_levels = self.to_s.split("::").count - 1 
        root_folder = File.dirname(__FILE__) + "/" + Array.new(num_class_hierarchy_levels).fill("..").join("/")
        class_folder = root_folder + "/" + classdir
        Dir[File.expand_path("#{class_folder}/*.rb")].uniq.each do |file|
          require file
        end
      end

      def self.find_all_subclasses_of args
        parent_class = args[ :parent_class ]
        constants = parent_class.constants
        candidates = []
        constants.each do | candidate |
          candidates << candidate.to_s.split('::').last if parent_class.const_get(candidate).class.to_s == "Class"
        end
        candidates
      end 

      def self.make_decimal digits
        if digits.start_with? "."
          "0#{digits}"
        elsif digits =~ /^\d+$/
          "#{digits}.0"
        else
          digits
        end        
      end

      def self.decimal_add decimal1, decimal2
        ( BigDecimal( decimal1 ) + BigDecimal( decimal2 ) ).truncate(8).to_s("F")
      end

      def self.decimal_minus decimal1, decimal2
        ( BigDecimal( decimal1 ) - BigDecimal( decimal2 ) ).truncate(8).to_s("F")
      end

      def self.decimal_multiply decimal1, decimal2, decimal3 = "1.0"
        ( BigDecimal( decimal1 ) * BigDecimal( decimal2 ) * BigDecimal( decimal3 ) ).truncate(8).to_s("F")
      end

      def self.decimal_divide decimal1, decimal2
        ( BigDecimal( decimal1 ) / BigDecimal( decimal2 ) ).truncate(8).to_s("F")
      end

      def self.decimal_equal? decimal1, decimal2
        BigDecimal( decimal1 ) == BigDecimal( decimal2 )
      end
    end
  end
end