require 'ostruct'
require 'json'
class Db < OpenStruct

  def self.load
    JSON.parse(File.read("#{$settings.base_path}/data/save.json"), object_class: self)
  end

  def save(field, value)
    self[field] = value
    File.open("#{$settings.base_path}/data/save.json", "w") { |f| f.write self.to_h.to_json }
    $db = self
  end
end