#!/usr/bin/ruby
require 'ostruct'
require 'json'
require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'httparty'

require_relative 'lib/api/log_downloader'
require_relative 'lib/api/item'
require_relative 'lib/api/upgrade'
require_relative 'lib/api/treasury_endpoint'

require_relative 'lib/models/guild_model'
require_relative 'lib/models/log_item'
require_relative 'lib/models/motd_log'
require_relative 'lib/models/treasury_log'
require_relative 'lib/models/stash_log'
require_relative 'lib/models/upgrade_log'
require_relative 'lib/models/upgrade_model'

require_relative 'lib/presentation/motd_poster'
require_relative 'lib/presentation/discord_poster'
require_relative 'lib/presentation/treasury_poster'
require_relative 'lib/presentation/upgrade_poster'

require_relative 'lib/util/settings'
require_relative 'lib/util/db'
require_relative 'lib/util/log_parser'

class DoombotRunner
  def initialize
    $settings = Settings.load
    $db = Db.load
  end

  def motd
    MotdPoster.new(get_logs($db.last_motd).motd_logs).post
  end

  def treasury
    TreasuryEndpoint.new.moo($settings.guild_treasury_url)
    TreasuryPoster.new(get_logs($db.last_treasury).treasury_logs).post
  end
  
  def shov

  end

  def upgrade
    UpgradePoster.new(get_logs($db.last_upgrade).upgrade_logs).post
  end

  private 

  def get_logs(since)
    if(LogDownloader.new($settings.guild_log_url, since).download)
      return LogParser.new(File.read("#{$settings.base_path}/data/log.json"))
    else
      puts "No action"
      exit
    end
  end
end

if(['motd', 'treasury', 'upgrade'].include?(ARGV[0]))
  DoombotRunner.new.send(ARGV[0])
end
