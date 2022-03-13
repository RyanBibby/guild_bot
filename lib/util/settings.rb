require 'ostruct'
require 'json'
class Settings < OpenStruct

  def self.load
    JSON.parse(File.read('config/settings.json'), object_class: self)
  end

  def guild_log_url
    "https://api.guildwars2.com/v2/guild/#{guild_id}/log?access_token=#{api_key}&since=9812"
  end

end