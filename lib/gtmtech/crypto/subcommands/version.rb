require 'gtmtech/crypto/subcommand'
require 'gtmtech/crypto'

module Gtmtech
  module Crypto
    module Subcommands

      class Version < Subcommand

        def self.options
          []
        end

        def self.parse
          puts "gtmtech-crypto v#{Gtmtech::Crypto::VERSION}"
        end

      end

    end
  end
end
