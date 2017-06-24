require 'gtmtech/crypto/subcommand'

module Gtmtech
  module Crypto
    module Subcommands

      class Transaction < Subcommand

        def self.options
          [{:name => :from,
            :description => "Source of the transaction in the form <name>.<currency>=<sent amount> e.g. barclays.GBP=20.50",
            :short => 'n', 
            :type => :string},
           {:name => :tp,
            :description => "Destination of the transaction in the form <name>.<currency>=<received amount> e.g. kraken.BTC=0.40503",
            :short => 'c',
            :type => :string},
           {:name => :fees,
            :description => "Any fees EXTERNAL to the transaction, in the form <name>.<currency>=<amount> e.g. kraken.BTC=0.00001",
            :short => 't',
            :type => :string},
           {:name => :date,
            :description => "Date of transaction (be as specific as you can) e.g. 2017-06-24,11:23:45",
            :short => 'd',
            :type => :string}
          ]
        end

      end

    end
  end
end
