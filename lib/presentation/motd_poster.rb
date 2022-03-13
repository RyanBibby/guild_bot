class MotdPoster

  attr_accessor :logs
    
  def initialize(logs)
    self.logs = logs
  end

  def post
    log_to_post = logs.first
    DiscordPoster.new("_#{log_to_post.motd.strip}_ - #{log_to_post.user}").post
    $db.save("last_log_id", log_to_post.id)
    $db.save("last_motd", log_to_post.id)
  end

end