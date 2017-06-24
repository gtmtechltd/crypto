module Gtmtech
  module Crypto
    module Subcommands

      class NewAccount < Subcommand

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

      end

    end
  end
end
