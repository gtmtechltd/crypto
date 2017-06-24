require 'securerandom'

module Gtmtech
  module Crypto
    class Data

      def self.load
        @@path = "#{ENV['HOME']}/.crypto.yaml"
        unless File.exist? @@path
          File.open(@@path, 'w') do |file| 
            file.write("---\naccounts: {}\ntransactions: []\n")
          end
        end
        @@document = YAML.load(File.read(@@path))
      end

      def self.add_account name, currency, type, url
        if @@document[ "accounts" ].key? name
          currencies = @@document[ "accounts" ][ name ][ "currencies" ]
          currencies << currency          
          @@document[ "accounts" ][ name ][ "currencies" ] = currencies.uniq.sort
          @@document[ "accounts" ][ name ][ "type" ]       = type if type
          @@document[ "accounts" ][ name ][ "url" ]        = url if url
        else
          @@document[ "accounts" ][ name ] = { "currencies" => [ currency ], "type" => type, "url" => url }
        end
      end

      def self.list_accounts
        printf("%-10s %-10s %-60s\n", "name", "type", "currencies")
        puts "-" * 80
        @@document[ "accounts" ].each do |name, account_info|
          printf("%-10s %-10s %-60s\n", name, account_info[ "type" ], account_info[ "currencies" ].join(","))
        end
      end

      def self.add_transaction date, source_account, source_currency, source_amount, dest_account, dest_currency, dest_amount, fees_account, fees_currency, fees_amount
        id = SecureRandom.uuid
        @@document[ "transactions" ][ id ] = { "date"            => date, 
                                               "source_account"  => source_account,
                                               "source_currency" => source_currency,
                                               "source_amount"   => source_amount,
                                               "dest_account"    => dest_account,
                                               "dest_currency"   => dest_currency,
                                               "dest_amount"     => dest_amount,
                                               "fees_account"    => fees_account,
                                               "fees_currency"   => fees_currency,
                                               "fees_amount"     => fees_amount }
      end

      def self.list_transactions
        printf("%-36s %-20s %-15s %-15s %-15s %-15s\n", "id", "date", "src account", "src amount", "dest account", "dest amount")
        puts "-" * 120
        @@document[ "transactions" ].each do |id, txn|
          printf("%-36s %-20s %-15s %-15s %-15s %-15s\n", id, txn["date"], "#{txn["source_account"]}.#{txn["source_currency"]}", txn["source_amount"], "#{txn["dest_account"]}.#{txn["dest_currency"]}", txn["dest_amount"])
          if txn["fees_account"]
            printf("%-36s %-20s %-15s %-15s %-15s %-15s\n", id, txn["date"], "#{txn["fees_account"]}.#{txn["fees_currency"]}", txn["fees_amount"], "fees.#{txn["fees_currency"]}", txn["fees_amount"])
          end
        end
      end

      def self.delete_transaction id
        @@document[ "transactions" ].delete( id )        
      end

      def self.save
        File.open(@@path, 'w') do |file|
          file.write( @@document.to_yaml )
        end
      end

    end
  end
end