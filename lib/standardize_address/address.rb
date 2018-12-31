class StandardizeAddress::Address

  attr_reader :address

  @@all = Array.new

  def initialize(address_hash)
    @address = address_hash
    self.save
  end

  def self.all
    @@all
  end

  def name_exists?
    self.class.all.any?{ |address| address[:"Name"] == self.address[:"Name"] }
  end

  def name_index
    if name_exists?
      self.class.all.index{ |address| address[:"Name"] == self.address[:"Name"] }
    end
  end

  def save
    if name_exists?
      self.address.each do |key, value|
        self.class.all[name_index][key] = value
      end
    else
      self.class.all << self.address
    end
  end

  def self.view_list
    self.all.each_with_index do |address, index|
      puts "#{index + 1}) ".light_white + "#{self.list_format(address)}".green
    end
  end

  def self.list_format(address_hash)
    address = address_hash.reject{ |key, value| value.to_s.empty? || key == :"Note" || key == :"ZIP Code" || key == :"ZIP + 4"}.map{ |key, value| "#{value}" }.join(", ")

    "#{address}, #{address_hash[:"ZIP Code"]}-#{address_hash[:"ZIP + 4"]}"
  end
end
