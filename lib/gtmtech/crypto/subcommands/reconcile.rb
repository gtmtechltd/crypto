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
Usage (crypto #{self.prettyname}) [BTC=<current btc price> ETH=<current eth price> .... etc ...]

crypto #{self.prettyname}
  - reconcile all transactions

If you specify the current price (in GBP) of each coin, the summary will become more illuminating

Options:
EOS
        end

        def self.options
          []
        end

        def self.reconcile values
          Data.load
          Data.reconcile_transactions values
        end

        def self.execute
          values = {}
          while ARGV.length > 0
            current_valuation = ARGV.shift
            currency = current_valuation.split("=")[0]
            gbp_equiv = current_valuation.split("=")[1]
            values[ currency ] = gbp_equiv
          end
          self.reconcile values
        end

      end

    end
  end
end