class StandardizeAddress::Address

  attr_accessor :name, :address_1, :address_2, :city, :state, :zip_5, :zip_4, :text, :number

  @@all = Array.new

  def initialize(address_hash = {})
    address_hash.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.all
    @@all
  end

  def name_exists?
    self.class.all.any?{ |address| address.name == self.name }
  end

  def index
    self.class.all.index{ |address| address.name == self.name }
  end

  def save
    if name_exists?
      self.class.all[index] = self
    else
      self.class.all << self
    end
  end

  def self.view_list
    self.all.each_with_index do |address, index|
      puts "#{index + 1}) ".light_white + "#{self.list_format(address)}".green
    end
  end

  def self.list_format(address)
    [
      address.name,
      address.address_1,
      address.address_2,
      address.city,
      address.state,
      "#{address.zip_5}-#{address.zip_4}"
    ].compact.reject(&:empty?).join(", ")
  end
end
