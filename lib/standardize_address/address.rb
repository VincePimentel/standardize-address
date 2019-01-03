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

  #Returns true/false depending on whether name exists or not in @@all
  def name_exists?
    self.class.all.any?{ |address| address.name == self.name }
  end

  #Returns index of name saved in @@all
  def index
    self.class.all.index{ |address| address.name == self.name }
  end

  #Overwrite existing or add/push new instance in @@all
  def save
    if name_exists?
      self.class.all[index] = self
    else
      self.class.all << self
    end
  end

  #Displays all saved addresses in list view
  def self.view_list
    self.all.each_with_index do |address, index|
      puts "#{index + 1}) ".light_white + "#{self.list_format(address)}".green
    end
  end

  #Formats the given address to be displayed as a string
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

  # def self.format_address(index)
  #   address = self.all[index]
  #   {
  #     "Name": address.name,
  #     "Apt/Suite": address.address_1,
  #     "Street": address.address_2,
  #     "City": address.city,
  #     "State": address.state,
  #     "ZIP Code": address.zip_5,
  #     "ZIP + 4": address.zip_4,
  #     "Note": address.text
  #   }.reject{ |key, value| value.to_s.empty? }
  # end
end
