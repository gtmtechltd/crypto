require 'gtmtech/crypto/utils'
require 'gtmtech/crypto/cli/subcommand'

module Gtmtech
  module Crypto
    class CLI

      def self.parse

        Utils.require_dir 'hiera/backend/eyaml/subcommands'
        subcommands = Utils.find_all_subclasses_of({ :parent_class => Gtmtech::Crypto::Cli::Subcommands }).collect {|classname| Utils.snakecase classname}

        subcommand = ARGV.shift
        subcommand = case subcommand
          when nil
            ARGV.delete_if {true}
            "unknown_command"
          when /^\-/
            ARGV.delete_if {true}
            "help"
          else
            subcommand
        end

        command_class = Subcommand.find subcommand

        options = command_class.parse

      end

    end
  end
end
