class UpgradeModel < GuildModel
  attr_accessor :id, :name, :description, :type

  def unlock?
    self.type == 'Unlock'
  end

end

