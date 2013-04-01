require 'open-uri'
require 'json'
require 'timeout'
require 'welaika_suspenders/version'

module WelaikaSuspenders
  module VersionCheck
    ENDPOINT = 'https://rubygems.org/api/v1/versions/welaika-suspenders.json'

    def self.check_if_up_to_date!
      data = Timeout::timeout(10) do
        JSON.parse(open(ENDPOINT).read)
      end
      latest_version = data.first["number"]
      up_to_date = Gem::Version.new(latest_version) <= Gem::Version.new(WelaikaSuspenders::VERSION)
      unless up_to_date
        puts "[WARNING] It looks like welaika-suspenders has been updated (v#{latest_version})! It is strongly suggested to upgrade to the latest version available with the following command:\n\ngem update welaika-suspenders\n\n"
        puts "To cancel the execution of the command, press CTRL+C. To continue, just press anything.\n\n"
        gets
      end
    rescue SocketError, Timeout::Error
      puts "[WARNING] I could not check if this is the latest version available of the gem!\n"
      puts "To cancel the execution of the command, press CTRL+C. To continue, just press anything.\n\n"
      gets
    end
  end
end
