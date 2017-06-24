require 'gtmtech/crypto/subcommand'

module Gtmtech
  module Crypto
    module Subcommands

      class Version < Subcommand

        def self.options
          []
        end

        def self.parse
          puts "Version:"
        end

      end

    end
  end
end
