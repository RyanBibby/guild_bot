class DiscordPoster

  attr_accessor :message
    
  def initialize(message)
    self.message = message
  end

  def post
    puts "****** POSTNG TO DISCORD ******"
    puts message
    options = {
      body: {
        "content" => self.message
      },
      headers: { 
        "content_type"  => "application/json",
      }
    }
    if($settings.live)
      HTTParty.post(
        $settings.webhook_url,
        options
      )
    end
    puts "*******************************"
  end
end