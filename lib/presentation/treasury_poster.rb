class TreasuryPoster

  attr_accessor :logs
    
  def initialize(logs)
    self.logs = logs
  end

  def post
    return if logs.nil?
    DiscordPoster.new(generate_summary).post
    $db.save("last_log_id", id_of_last_log)
    $db.save("last_motd", id_of_last_log)
  end

  private

  def generate_summary
    # Should really seperate presention from data generation but meh, it's a weekend
    logs.group_by(&:user).map do |user, items| 
      "Recently #{user} has deposited into the treasury: \r\n" + items.group_by { |n| n.item_id }.map do  |item, data|
        name = Item.from_id(item)
        number = data.inject(0) { |sum, item| sum + item.count } 
        "* #{number} x #{name}"
      end.join("\r\n")
    end.join("\r\n\r\n")
  end

  def id_of_last_log
    logs.first.id
  end

end