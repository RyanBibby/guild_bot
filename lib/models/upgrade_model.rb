class UpgradeModel < GuildModel
  attr_accessor :id, :name, :description, :type, :costs

  def unlock?
    self.type == 'Unlock'
  end

end

