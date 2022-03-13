class Item
  attr_accessor :name

  def self.from_id(id)
    uri = URI("https://api.guildwars2.com/v2/items?ids=#{id}")
    res = Net::HTTP.get_response(uri)
    if(res.code == '200')
      JSON.parse(res.body).first["name"]
    else
      "UNKNOWN"
    end
  end
end