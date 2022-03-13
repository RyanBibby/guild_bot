class Upgrade
  attr_accessor :name

  def self.from_id(id)
    uri = URI("https://api.guildwars2.com/v2/guild/upgrades/#{id}")
    res = Net::HTTP.get_response(uri)
    if(res.code == '200')
      res.body
    else
      { name: "UKNOWN" }.to_json
    end
  end
end