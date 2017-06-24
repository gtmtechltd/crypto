require 'gtmtech/crypto/subcommand'
require 'gtmtech/crypto'
require 'gtmtech/crypto/CLI'

module Gtmtech
  module Crypto
    module Subcommands

      class Help < Subcommand

        def self.options
          []
        end

        def self.execute
          puts <<-EOS
Welcome to gtmtech-crypto #{Gtmtech::Crypto::VERSION} 

Usage:
crypto <subcommand> ... [global-opts] [subcommand-opts]

Available subcommands:
#{Gtmtech::Crypto::CLI.subcommands.collect {|command|
  command_class = Gtmtech::Crypto::Subcommands.const_get(Utils.camelcase command)
  sprintf "%15s: %-65s", command.downcase, command_class.description unless command_class.hidden?
}.compact.join("\n")}

For more help on an individual command, use --help on that command

EOS
        end

        def self.description
          "print help message"
        end

      end

    end
  end
end
