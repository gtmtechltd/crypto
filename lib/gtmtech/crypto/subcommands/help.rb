require 'gtmtech/crypto/subcommand'

module Gtmtech
  module Crypto
    module Subcommands

      class Help < Subcommand

        def self.options
          []
        end

        def parse
          puts "Usage:"
        end

      end

    end
  end
end
