require 'ostruct'
require 'json'
class Db < OpenStruct

  def self.load
    JSON.parse(File.read(file_location), object_class: self)
  end

  def save(field, value)
    self[field] = value
    File.open(self.file_location, "w") { |f| f.write self.to_h.to_json }
    $db = self
  end

  def self.file_location
    "#{$settings.base_path}/data/save.json"
  end

end