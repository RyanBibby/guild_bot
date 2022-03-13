require 'ostruct'
require 'json'
require 'rubygems'
require 'bundler/setup'
require 'net/http'

Bundler.require(:default)

require_relative 'lib/api/log_downloader'
require_relative 'lib/api/item'

require_relative 'lib/models/guild_model'
require_relative 'lib/models/log_item'
require_relative 'lib/models/motd_log'
require_relative 'lib/models/treasury_log'
require_relative 'lib/models/stash_log'

require_relative 'lib/presentation/motd_poster'
require_relative 'lib/presentation/discord_poster'
require_relative 'lib/presentation/treasury_poster'

require_relative 'lib/util/settings'
require_relative 'lib/util/db'
require_relative 'lib/util/log_parser'

class DoombotRunner
  def initialize
    $settings = Settings.load
    $db = Db.load
  end

  def run
    if(LogDownloader.new($settings.guild_log_url).download)
      logs = LogParser.new(File.read('./data/log.json'))
      MotdPoster.new(logs.motd_logs).post
      TreasuryPoster.new(logs.treasury_logs).post
    else
      puts "No action"
      exit
    end
  end
end

DoombotRunner.new.run
