module Gtmtech
  module Crypto
    class Data

      def self.load
        path = "#{ENV['HOME']}/.crypto.yaml"
        unless File.exist? path
          File.open(path, 'w') do |file| 
            file.write("---\naccounts: []\ntransactions: []\n")
          end
        end
        @@document = YAML.load(File.read(path))
      end

      def self.add_account name, currency, type
        @@document[ :accounts ] << { :name => name, :currency => currency, :type => type }
      end

      def self.save
        puts "saving"
      end

    end
  end
end