require 'ostruct'
require 'json'
class Settings < OpenStruct

  def self.load
    JSON.parse(File.read("#{File.dirname(__FILE__)}/../../config/settings.json"), object_class: self)
  end

  def guild_log_url
    "https://api.guildwars2.com/v2/guild/#{guild_id}/log?access_token=#{api_key}&"
  end
  
  def guild_treasury_url
    "https://api.guildwars2.com/v2/guild/#{guild_id}/treasury?access_token=#{api_key}"
  end
end
