require 'gtmtech/crypto/subcommand'
require 'gtmtech/crypto/data'
require 'yaml'

module Gtmtech
  module Crypto
    module Subcommands

      class Account < Subcommand

        def self.description
          "manage accounts"
        end

        def self.usage
          <<-EOS
Usage (crypto #{self.prettyname})

crypto #{self.prettyname} new --name=<s> --currencies=<s> [--type=<s> --url=<s>]
  - create a new account

crypto #{self.prettyname} list
  - list all accounts

Options:
EOS
        end

        def self.options
          [{:name => :name,
            :description => "Name of the account",
            :short => 'n', 
            :type => :string},
           {:name => :currencies,
            :description => "Comma separated list of currencies this account supports",
            :short => 'c',
            :type => :string},
           {:name => :type,
            :description => "(optional) Type of account - options are wallet,exchange,bank",
            :short => 't',
            :type => :string},
           {:name => :url,
            :description => "(optional) URL for account website",
            :short => 'u',
            :type => :string}
          ]
        end

        def self.create
          self.error "--name required" unless @@options[:name_given]
          self.error "--currencies required" unless @@options[:currencies_given]

          Data.load
          @@options[:currencies].split(",").each do |currency|
            Data.add_account( @@options[:name], currency, @@options[:type], @@options[:url] )
          end
          Data.save
        end

        def self.list
          Data.load
          Data.list_accounts
        end

        def self.execute
          verb = ARGV.shift
          case verb.downcase
          when "new", "create", "add"
            self.create
          when "list"
            self.list
          else
            self.error "account takes an action [new, list] . See --help for more info"
          end
        end

      end

    end
  end
end
