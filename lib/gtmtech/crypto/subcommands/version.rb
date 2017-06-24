require 'gtmtech/crypto/subcommand'
require 'gtmtech/crypto'

module Gtmtech
  module Crypto
    module Subcommands

      class Version < Subcommand

        def self.options
          []
        end

        def self.execute
          puts "gtmtech-crypto v#{Gtmtech::Crypto::VERSION}"
        end

        def self.description
          "output version information"
        end

      end

    end
  end
end
