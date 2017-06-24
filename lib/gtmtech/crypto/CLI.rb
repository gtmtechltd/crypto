require 'gtmtech/crypto/utils'
require 'gtmtech/crypto/subcommand'

module Gtmtech
  module Crypto
    class CLI

      attr_reader :subcommands

      def self.parse

        Utils.require_dir 'gtmtech/crypto/subcommands'
        @@subcommands = Utils.find_all_subclasses_of({ :parent_class => Gtmtech::Crypto::Subcommands }).collect {|classname| Utils.snakecase classname}

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

      def self.subcommands
        @@subcommands
      end

    end
  end
end

