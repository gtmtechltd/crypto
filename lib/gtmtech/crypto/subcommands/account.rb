require 'gtmtech/crypto/subcommand'
require 'gtmtech/crypto/data'
require 'yaml'

module Gtmtech
  module Crypto
    module Subcommands

      class Account < Subcommand

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
            :description => "Type of account - options are wallet,exchange,bank",
            :short => 't',
            :type => :string}
          ]
        end

        def self.create options
          self.error "--name required" unless options[:name_given]
          self.error "--currencies required" unless options[:currencies_given]
          self.error "--type required" unless options[:type_given]

          Data.add_account( options[:name], options[:currencies], options[:type] )
        end

        def self.description
          "manage accounts"
        end

      end

    end
  end
end
