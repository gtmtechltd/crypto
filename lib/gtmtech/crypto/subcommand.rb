require 'base64'
require 'yaml'
require 'trollop'
# require 'gtmtech/crypto/subcommands/unknown_command'
require 'gtmtech/crypto'

module Gtmtech
  module Crypto

    class Subcommand

      class << self
        attr_accessor :global_options, :options, :helptext
      end

      @@global_options = [
         {:name          => :version,
            :description => "Show version information"},
         {:name          => :help,
            :description => "Information on how to use this command",
            :short       => 'h'}
        ]
      
      def self.all_options 
        options = @@global_options.dup
        options += self.options if self.options
        { :options => options }
      end

      def self.find commandname = "unknown_command"
        begin
          require "gtmtech/crypto/subcommands/#{commandname.downcase}"
        rescue Exception => e
          require "gtmtech/crypto/subcommands/unknown_command"
          return Gtmtech::Crypto::Subcommands::UnknownCommand
        end          
        command_module = Module.const_get('Gtmtech').const_get('Crypto').const_get('Subcommands')
        command_class = Utils.find_closest_class :parent_class => command_module, :class_name => commandname
        if command_class
          command_class
        else
          require "gtmtech/crypto/subcommands/unknown_command"
          Gtmtech::Crypto::Subcommands::UnknownCommand
        end
      end

      def self.parse

        me = self
        all = self.all_options

        @@options = Trollop::options do

          version "gtmtech-crypto version " + Gtmtech::Crypto::VERSION.to_s
          banner "#{me.usage}\n\n"

          all[:options].each do |available_option|

            skeleton = {:description => "",
                        :short => :none}

            skeleton.merge! available_option
            opt skeleton[:name], 
                skeleton[:desc] || skeleton[:description],  #legacy plugins 
                :short => skeleton[:short], 
                :default => skeleton[:default], 
                :type => skeleton[:type]

          end

        end

      end

      def self.validate args
        args
      end

      def self.usage
        "Usage: \ncrypto #{self.prettyname} [global-options] [options]\nDescription: #{self.description}"
      end

      def self.description
        "no description"
      end

      def self.helptext
        "Usage: crypto #{self.prettyname} [options]"
      end

      def self.execute
        raise StandardError, "This command is not implemented yet (#{self.to_s.split('::').last})"
      end

      def self.prettyname
        Utils.snakecase self.to_s.split('::').last
      end

      def self.hidden?
        false
      end

      def self.error message
        puts "Error:"
        puts message
        exit 1
      end

    end
  end
end