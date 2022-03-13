require('active_model')
class GuildModel

  include ActiveModel::Model
  include ActiveModel::Serializers::JSON

  def attributes=(hash)
    hash.each do |key, value|
    send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

  def attributes
    instance_values
  end

end