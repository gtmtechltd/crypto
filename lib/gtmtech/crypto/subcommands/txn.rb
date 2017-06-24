require 'gtmtech/crypto/subcommand'

module Gtmtech
  module Crypto
    module Subcommands

      class Txn < Subcommand

        def self.description
          "manage accounts"
        end

        def self.usage
          <<-EOS
Usage (crypto #{self.prettyname})

crypto #{self.prettyname} new --date=<s> --from=<s> --to=<s> [--fees=<s>]
  - create a new transaction

crypto #{self.prettyname} delete --id=<s>
  - delete a transaction

crypto #{self.prettyname} list
  - list all transactions


Options:
EOS
        end

        def self.options
          [{:name => :date,
            :description => "Date of transaction (in format 2017-06-24,11:23:45 or \"now\")",
            :short => 'd',
            :type => :string},
           {:name => :from,
            :description => "Source of the transaction in the form <name>.<currency>=<sent amount> e.g. barclays.GBP=20.50",
            :short => 'n', 
            :type => :string},
           {:name => :to,
            :description => "Destination of the transaction in the form <name>.<currency>=<received amount> e.g. kraken.BTC=0.40503",
            :short => 't',
            :type => :string},
           {:name => :fees,
            :description => "Any fees EXTERNAL to the transaction, in the form <name>.<currency>=<amount> e.g. kraken.BTC=0.00001",
            :short => 'f',
            :type => :string},
           {:name => :id,
            :description => "Specify the id you wish to amend/delete in a delete operation",
            :short => 'i',
            :type => :string}
          ]
        end

        def self.create
          self.error "--date required" unless @@options[:date_given]
          self.error "--date must be in format \"now\" or YYYY-MM-DD,hh:mm:ss" unless (@@options[:date] == "now" or @@options[:date] =~ /\d\d\d\d\-\d\d\-\d\d,\d\d:\d\d:\d\d/)

          self.error "--from required" unless @@options[:from_given]
          self.error "--from must be in format <name>.<currency>=<amount>" unless @@options[:from] =~ /^\w+\.\w+=[\d\.]+$/

          self.error "--to required"   unless @@options[:to_given]
          self.error "--to must be in format <name>.<currency>=<amount>"   unless @@options[:to] =~ /^\w+\.\w+=[\d\.]+$/

          if @@options[:fees_given]
            self.error "--fees must be in format <name>.<currency>=<amount>" unless @@options[:fees] =~ /^\w+\.\w+=[\d\.]+$/
          end

          source_account  = @@options[:from].split(".")[0]
          source_currency = @@options[:from].split(".")[1].split("=")[0]
          source_amount   = @@options[:from].split("=")[1]
          self.error "--from: txn amount must be a decimal or integer" unless source_amount =~ /^\d*\.\d+$/ or source_amount =~ /^\d+$/

          dest_account  = @@options[:to].split(".")[0]
          dest_currency = @@options[:to].split(".")[1].split("=")[0]
          dest_amount   = @@options[:to].split("=")[1]
          self.error "--to: txn amount must be a decimal or integer" unless dest_amount =~ /^\d*\.\d+$/ or dest_amount =~ /^\d+$/

          self.error "cannot create a self-referential transaction" if source_account == dest_account and source_currency == dest_currency

          fees_account  = nil
          fees_currency = nil
          fees_amount   = nil
          if @@options[:fees_given]
            fees_account  = @@options[:fees].split(".")[0]
            fees_currency = @@options[:fees].split(".")[1].split("=")[0]
            fees_amount   = @@options[:fees].split("=")[1]
          end

          Data.load
          self.error "The account #{source_account}.#{source_currency} does not yet exist" unless Data.account_exists? source_account, source_currency
          self.error "The account #{dest_account}.#{dest_currency} does not yet exist"     unless Data.account_exists? dest_account, dest_currency
          Data.add_transaction @@options[:date], source_account, source_currency, source_amount, dest_account, dest_currency, dest_amount, fees_account, fees_currency, fees_amount
          Data.save
        end

        def self.list
          Data.load
          Data.list_transactions
        end

        def self.delete
          self.error "--id required" unless @@options[:id_given]
          Data.load
          Data.delete_transaction @@options[:id]
          Data.save
        end

        def self.execute
          verb = ARGV.shift
          case verb.downcase
          when "new", "create", "add"
            self.create
          when "list"
            self.list
          when "delete"
            self.delete
          else
            self.error "transaction takes an action [new, list, delete] . See --help for more info"
          end
        end

      end

    end
  end
end
