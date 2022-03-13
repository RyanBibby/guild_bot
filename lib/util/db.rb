require 'ostruct'
require 'json'
class Db < OpenStruct

  FILE_LOCATION = 'data/save.json'

  def self.load
    JSON.parse(File.read(FILE_LOCATION), object_class: self)
  end

  def save(field, value)
    self[field] = value
    File.open(FILE_LOCATION, "w") { |f| f.write self.to_h.to_json }
    $db = self
  end

end