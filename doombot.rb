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
    TreasuryEndpoint.new.moo($settings.guild_treasury_url)
    progress_for(424)
  end

  def upgrade
    UpgradePoster.new(get_logs($db.last_upgrade).upgrade_logs).post
  end

  private 

  def progress_for(item_id)
    td = JSON.parse File.read("#{$settings.base_path}/data/treasury.json")

    model = UpgradeModel.new.from_json(Upgrade.from_id(item_id))
    
    output ="Progess on " + model.name + ":\r\n"
    model.costs.select { |cost| cost["type"] == "Item"}.each do |item|
      we_have = td.select { |moo| moo["item_id"] == item["item_id"] }.first["count"]

      if (we_have >= item["count"])
        output = output + "   * ~~" + item["name"] + " (#{we_have} / #{item["count"]})~~\r\n"
      else
        output = output + "   * " + item["name"] + " (#{we_have} / #{item["count"]})\r\n"
      end
      
    end
    DiscordPoster.new(output).post
  end

  def get_logs(since)
    if(LogDownloader.new($settings.guild_log_url, since).download)
      return LogParser.new(File.read("#{$settings.base_path}/data/log.json"))
    else
      puts "No action"
      exit
    end
  end
end

if(['motd', 'treasury', 'upgrade', 'shov'].include?(ARGV[0]))
  DoombotRunner.new.send(ARGV[0])
end
