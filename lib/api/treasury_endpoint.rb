class TreasuryEndpoint
  attr_accessor :item_id, :count, :needed_by

  def moo(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    if(res.code == '200')
      data = JSON.parse(res.body)
      File.open("#{$settings.base_path}/data/treasury.json", "w") { |f| f.write data.to_json }
    end
  end
end
