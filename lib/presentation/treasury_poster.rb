class TreasuryPoster

  attr_accessor :logs
    
  def initialize(logs)
    self.logs = logs
  end

  def post
    return if logs.nil?
    DiscordPoster.new(generate_summary).post
    $db.save("last_log_id", id_of_last_log)
    $db.save("last_treasury", id_of_last_log)
  end

  private

  def generate_summary

    td = JSON.parse File.read("#{$settings.base_path}/data/treasury.json")
    # Should really seperate presention from data generation but meh, it's a weekend
    logs.group_by(&:user).map do |user, items| 
      "Recently #{user} has deposited into the treasury: \r\n" + items.group_by { |n| n.item_id }.map do  |item, data|
        name = Item.from_id(item)
        number = data.inject(0) { |sum, item| sum + item.count }
        if !td.select { |moo| moo["item_id"] == item }.empty? 
        total = td.select { |moo| moo["item_id"] == item }.first["count"]

        required = td.select { |moo| moo["item_id"] == item }.first["needed_by"].inject(0) { |sum, i| sum + i["count"].to_i }      
    "* #{number} x #{name} (we have #{total} of #{required} required)"
        else 
	"* #{number} x #{name} (We're full and no longer need these)"      
        end 
      end.join("\r\n")
    end.join("\r\n\r\n")
  end

  def id_of_last_log
    logs.first.id
  end

end
