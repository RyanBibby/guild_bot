class UpgradePoster

  attr_accessor :logs
    
  def initialize(logs)
    self.logs = logs
  end

  def post
    return if logs.nil?
    get_unlocks.each do |upgrade|
      DiscordPoster.new("The Doomskulls have unlocked \"#{upgrade.name}!\"").post
    end
    $db.save("last_log_id", id_of_last_log)
    $db.save("last_upgrade", id_of_last_log)
  end

  private

  def get_unlocks
    logs.map do |log|
      UpgradeModel.new.from_json (
        Upgrade.from_id(log.upgrade_id)
      )
    end.select(&:unlock?)
  end

  def id_of_last_log
    logs.first.id
  end

end