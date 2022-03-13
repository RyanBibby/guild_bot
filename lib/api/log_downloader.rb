class LogDownloader

  attr_accessor :url, :since

  def initialize(url, since)
    self.url = url
    self.since = since
  end

  def download
    uri = URI(url + "since=#{since}")
    res = Net::HTTP.get_response(uri)

    
    if(res.code == '200') 
      puts "Downloaded log"
      log_raw = JSON.parse(res.body)
      if(log_raw.empty?)
        puts "Nothing new"
        return false
      end
      File.open("data/log.json", "w") { |f| f.write log_raw.to_json }
      return true
    else
      puts "Failed to download log"
      return false
    end
  end
end