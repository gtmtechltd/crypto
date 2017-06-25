require 'securerandom'
require 'gtmtech/crypto/utils'
require 'colorize'

module Gtmtech
  module Crypto
    class Data

      def self.load
        if ENV['CRYPTO_PROFILE']
          @@path = "#{ENV['HOME']}/.crypto.#{ENV['CRYPTO_PROFILE']}.yaml"
        else
          @@path = "#{ENV['HOME']}/.crypto.yaml"
        end
        unless File.exist? @@path
          File.open(@@path, 'w') do |file| 
            file.write("---\naccounts: {}\ntransactions: {}\n")
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
        puts "Accounts for profile \"#{ENV['CRYPTO_PROFILE'] || 'main'}\":"
        printf("%-10s %-10s %-60s\n", "name", "type", "currencies")
        puts "-" * 80
        @@document[ "accounts" ].each do |name, account_info|
          printf("%-10s %-10s %-60s\n", name, account_info[ "type" ], account_info[ "currencies" ].join(","))
        end
      end

      def self.account_exists? name, currency
        return false unless @@document[ "accounts" ].key? name
        return false unless @@document[ "accounts" ][ name ][ "currencies" ].include? currency 
        true
      end

      def self.add_transaction date, source_account, source_currency, source_amount, dest_account, dest_currency, dest_amount, fees_account, fees_currency, fees_amount, references, percentage
        if date.downcase == "now"
          date = Time.now.to_s.split(" ").take(2).join(",")
        end

        source_amount = Utils.make_decimal source_amount
        dest_amount = Utils.make_decimal dest_amount

        id = SecureRandom.uuid.to_s
        @@document[ "transactions" ][ id ] = { "date"            => date, 
                                               "source_account"  => source_account,
                                               "source_currency" => source_currency,
                                               "source_amount"   => source_amount,
                                               "dest_account"    => dest_account,
                                               "dest_currency"   => dest_currency,
                                               "dest_amount"     => dest_amount,
                                               "fees_account"    => fees_account,
                                               "fees_currency"   => fees_currency,
                                               "fees_amount"     => fees_amount,
                                               "references"      => references,
                                               "percentage"      => percentage }
      end

      def self.list_transactions
        outputs = []

        puts "Transactions for profile \"#{ENV['CRYPTO_PROFILE'] || 'main'}\":\n".red
        cols = "%-36s %-20s %-14s %-15s %-15s %-15s %-12s %-14s %s"
        puts sprintf("#{cols}", 
                      "id", 
                      "date", 
                      "%age", 
                      "src account", 
                      "src amount", 
                      "dest account", 
                      "dest amount", 
                      "ratio", 
                      "reference_ids").light_blue
        puts "-" * 160
        @@document[ "transactions" ].each do |id, txn|
          ratio = ""
          if txn["source_currency"] != txn["dest_currency"]
            ratio = Utils.decimal_divide( txn["source_amount"], txn["dest_amount"] )
          end
          outputs << { :date => txn["date"],
                       :lines => [] }
          if Utils.decimal_equal?( txn[ "percentage" ], "100.0" )
            outputs.last[ :lines ] << sprintf("#{cols}", 
                                              id, 
                                              txn["date"], 
                                              "-",
                                              "#{txn[ "source_account"] }.#{txn[ "source_currency"] }", 
                                              txn["source_amount"], 
                                              "#{txn[ "dest_account"] }.#{txn[ "dest_currency"] }", 
                                              txn[ "dest_amount" ], 
                                              ratio, 
                                              txn[ "references" ][0..20] )
          else
            outputs.last[ :lines ] << sprintf("#{cols}", 
                                              id, 
                                              txn["date"], 
                                              "100.0", 
                                              "#{txn["source_account"]}.#{txn["source_currency"]}", 
                                              txn["source_amount"], 
                                              "#{txn["dest_account"]}.#{txn["dest_currency"]}", 
                                              txn[ "dest_amount" ], 
                                              ratio, 
                                              txn[ "references" ][0..20] ).light_black
            outputs.last[ :lines ] << sprintf("#{cols}", 
                                              "", 
                                              "", 
                                              Utils.decimal_add( txn["percentage"], "0.0" ), 
                                              "#{txn["source_account"]}.#{txn["source_currency"]}", 
                                              Utils.decimal_multiply( txn["source_amount"], txn["percentage"], "0.01" ), 
                                              "#{txn["dest_account"]}.#{txn["dest_currency"]}", 
                                              Utils.decimal_multiply( txn[ "dest_amount" ], txn[ "percentage" ], "0.01" ), 
                                              "", 
                                              "" )
          end
          if txn["fees_account"]
            if Utils.decimal_equal?( txn[ "percentage" ], "100.0" )
              outputs.last[ :lines ] << sprintf("#{cols}", 
                                                "",
                                                "",
                                                "-",
                                                "#{txn["fees_account"]}.#{txn["fees_currency"]}",
                                                txn["fees_amount"],
                                                "FEES.#{txn["fees_currency"]}",
                                                txn[ "fees_amount" ],
                                                "",
                                                "" )
            else
              outputs.last[ :lines ] << sprintf("#{cols}", 
                                                "",
                                                "",
                                                "100.0",
                                                "#{txn["fees_account"]}.#{txn["fees_currency"]}",
                                                txn["fees_amount"], 
                                                "FEES.#{txn["fees_currency"]}",
                                                txn[ "fees_amount" ], 
                                                "",
                                                "" ).light_black
              outputs.last[ :lines ] << sprintf("#{cols}", 
                                                "",
                                                "",
                                                Utils.decimal_add( txn["percentage"], "0.0" ),
                                                "#{txn["fees_account"]}.#{txn["fees_currency"]}",
                                                Utils.decimal_multiply( txn["fees_amount"], txn["percentage"], "0.01" ),
                                                "FEES.#{txn["fees_currency"]}",
                                                Utils.decimal_multiply( txn[ "fees_amount" ], txn["percentage"], "0.01" ),
                                                "",
                                                "" )
            end
          end
        end

        outputs.sort_by { |k| k[ :date ] }.each do |k|
          k[ :lines ].each do |line|
            puts line
          end
        end

      end

      def self.delete_transaction id
        @@document[ "transactions" ].delete( id )        
      end

      def self.reconcile_transactions conversions
        self.list_transactions
        puts ""
        cols = "%-20s %-10s %-20s %-30s"
        puts sprintf("#{cols}", "account", "currency", "amount", "GBP equivalent").light_blue
        puts "-" * 120
        fees = {}
        currencies = {}
        @@document[ "accounts" ].each do | name, account_info |
          account_info[ "currencies" ].sort.each do | currency |
            total     = "0.0"
            txn_total = "0.0"
            @@document[ "transactions" ].each do |id, txn|

              # explicit fees
              if txn[ "fees_account" ] == name and txn[ "fees_currency" ] == currency
                # print "#{txn_total} :     - #{txn[ "percentage" ]}% of #{txn[ "fees_amount" ]}".blue
                txn_total = Utils.decimal_minus( txn_total, Utils.decimal_multiply( txn[ "fees_amount" ], txn[ "percentage" ], "0.01" ) )
                # puts " = #{txn_total}".blue
                unless fees.key? currency
                  fees[ currency ] = "0.0"
                end
                fees[ currency ] = Utils.decimal_add( fees[ currency ], Utils.decimal_multiply( txn[ "fees_amount" ], txn[ "percentage" ], "0.01" ) )
              end

              # account reconciliation
              if txn[ "source_account" ] == name and txn[ "source_currency" ] == currency
                # print "#{txn_total} :     - #{txn[ "percentage" ]}% of #{txn[ "source_amount" ]}".blue
                txn_total = Utils.decimal_minus( txn_total, Utils.decimal_multiply( txn[ "source_amount" ], txn[ "percentage" ], "0.01" ) )
                # puts " = #{txn_total}".blue
 
                # implicit fees
                if txn[ "source_currency" ] == txn[ "dest_currency" ] and txn[ "source_amount" ] != txn[ "dest_amount" ]
                  implicit_fees = Utils.decimal_minus( txn[ "source_amount" ], txn[ "dest_amount" ] )
                  unless fees.key? currency
                    fees[ currency ] = "0.0"
                  end
                  fees[ currency ] = Utils.decimal_add( fees[ currency ], Utils.decimal_multiply( implicit_fees, txn[ "percentage" ], "0.01" ) )
                end

              end
              if txn[ "dest_account" ] == name and txn[ "dest_currency" ] == currency
                # print "#{txn_total} :     + #{txn[ "percentage" ]}% of #{txn[ "dest_amount" ]}".blue
                txn_total = Utils.decimal_add( txn_total, Utils.decimal_multiply( txn[ "dest_amount" ], txn[ "percentage" ], "0.01" ) )
                # puts " = #{txn_total}".blue
              end
            end
            unless currencies.key? currency
              currencies[ currency ] = "0.0"
            end
            currencies[ currency ] = Utils.decimal_add( currencies[ currency ], txn_total )
            gbp_equiv = "?"
            gbp_equiv = Utils.decimal_multiply( txn_total, conversions[ currency ] ) if conversions.key? currency
            puts sprintf( "#{cols}", name, currency, txn_total, gbp_equiv )
          end
        end
        fees.keys.sort.each do |currency|
          unless currencies.key? currency
            currencies[ currency ] = "0.0"
          end
          gbp_equiv = "?"
          gbp_equiv = Utils.decimal_multiply( fees[ currency ], conversions[ currency ] ) if conversions.key? currency
          puts sprintf( "#{cols}", "**FEES**", currency, fees[ currency ], gbp_equiv)
        end

        puts ""
        cols = "%-10s %-20s"
        puts sprintf( "#{cols}", "currency", "reconciliation" ).light_blue
        puts "-" * 120
        currencies.keys.sort.each do |currency|
          currency_fees = fees[ currency ] || "0.0"
          printf( "%-10s %-20s\n", currency, Utils.decimal_add( currencies[ currency ], currency_fees ) )
        end

        gbp_total = "0.0"
        gbp_known = true
        puts ""
        cols = "%-10s %-20s %-20s"
        puts sprintf( "#{cols}", "currency", "totals", "GBP equivalent" ).light_blue
        puts "-" * 120
        currencies.keys.sort.each do |currency|
          amount = currencies[ currency ]
          if conversions.key? currency
            gbp_equiv = Utils.decimal_multiply( amount, conversions[ currency ] )
            puts sprintf( "#{cols}", currency, currencies[ currency ], gbp_equiv )
            gbp_total = Utils.decimal_add( gbp_total, gbp_equiv )
          else
            puts sprintf( "#{cols}", currency, currencies[ currency ], "?" )
            gbp_known = false
          end
        end

        puts ""
        puts "profit/loss (equivalent GBP)".blue
        puts "----------------------------"
        if gbp_known
          puts gbp_total
        else
          puts "unknown - specify conversions on command-line - see --help"
        end
      end

      def self.save
        File.open(@@path, 'w') do |file|
          file.write( @@document.to_yaml )
        end
      end

    end
  end
end