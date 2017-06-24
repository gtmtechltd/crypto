require 'gtmtech/crypto/subcommand'

module Gtmtech
  module Crypto
    module Subcommands

      class UnknownCommand < Subcommand

        def self.options
          []
        end

        def self.execute
          puts "Unknown command"
        end

      end

    end
  end
end
