require 'gtmtech/crypto/subcommand'

module Gtmtech
  module Crypto
    module Subcommands

      class Reconcile < Subcommand

        def self.description
          "reconcile transactions"
        end

        def self.usage
          <<-EOS
Usage (crypto #{self.prettyname})

crypto #{self.prettyname}
  - reconcile all transactions

Options:
EOS
        end

        def self.options
          []
        end

        def self.reconcile
          Data.load
          Data.reconcile_transactions
        end

        def self.execute
          self.reconcile
        end

      end

    end
  end
end