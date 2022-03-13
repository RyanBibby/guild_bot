class LogParser

  attr_accessor :log_hash

  def initialize(raw_log)
    self.log_hash = JSON.parse(raw_log).group_by { |log| log["type"] }
  end

  def motd_logs
    return if self.log_hash["motd"].nil?
    self.log_hash["motd"].map do |log|
      MotdLog.new.from_json(log.to_json)
    end
  end

  def treasury_logs
    return if self.log_hash["treasury"].nil?
    self.log_hash["treasury"].map do |log|
      TreasuryLog.new.from_json(log.to_json)
    end
  end

  def stash_logs
    return if self.log_hash["stash"].nil?
    self.log_hash["stash"].map do |log|
      StashLog.new.from_json(log.to_json)
    end
  end

  def upgrade_logs
    return if self.log_hash["upgrade"].nil?
    self.log_hash["upgrade"].map do |log|
      UpgradeLog.new.from_json(log.to_json)
    end
  end

end