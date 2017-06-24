require 'base64'
require 'yaml'
require 'trollop'

class Gtmtech
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
            require "gtmtech/crypto/cli/subcommands/#{commandname.downcase}"
          rescue Exception => e
            require "gtmtech/crypto/cli/subcommands/unknown_command"
            return Gtmtech::Crypto::Cli::Subcommands::UnknownCommand
          end          
          command_module = Module.const_get('Gtmtech').const_get('Crypto').const_get('Cli').const_get('Subcommands')
          command_class = Utils.find_closest_class :parent_class => command_module, :class_name => commandname
          command_class || Gtmtech::Crypto::Cli::Subcommands::UnknownCommand
        end

        def self.parse

          me = self
          all = self.all_options

          options = Trollop::options do

            version "gtmtech-crypto version " + Gtmtech::Crypto::Accounting::VERSION.to_s
            banner ["crypto #{me.prettyname}: #{me.description}", me.helptext, "Options:"].compact.join("\n\n")

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

            # stop_on Eyaml.subcommands

          end

          if options[:verbose]
            Hiera::Backend::Eyaml.verbosity_level += 1
          end

          if options[:trace]
            Hiera::Backend::Eyaml.verbosity_level += 2
          end

          if options[:quiet]
            Hiera::Backend::Eyaml.verbosity_level = 0
          end

          if options[:encrypt_method]
            Hiera::Backend::Eyaml.default_encryption_scheme = options[:encrypt_method]
          end

          if all[:sources]
            all[:sources].each do |source|
              LoggingHelper::debug "Loaded config from #{source}"
            end
          end

          options

        end

        def self.validate args
          args
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

      end

    end
  end
end