class StandardizeAddress::Address

  @@all = Array.new

  def initialize(address_hash)
    @address = address_hash
    #@@all << address_hash
    save
  end

  def self.all
    @@all
  end

  def save
    #@address = formatted_address

    # @address.delete_if do |key, value|
    #   value.empty? || value.nil? || key == :return_text || key == :description
    # end

    if name_exists?
      @address.each do |key, value|
        self.class.all[name_index][key] = value
      end
    else
      #@address[:"Name"] = @address[:"Name"]
      self.class.all << @address
    end
  end

  def name_exists?
    self.class.all.any?{ |address| address[:"Name"] == @address[:"Name"] }
  end

  def name_index
    if name_exists?
      self.class.all.index{ |address| address[:"Name"] == @address[:"Name"] }
    end
  end

  def self.list_view
    #binding.pry
    self.all.each_with_index do |address, index|
      puts "#{index + 1}) #{self.list_view_format(address)}"
    end
  end

  def self.list_view_format(address_hash)
    address = address_hash.reject{ |key, value|
      key == :"Note" || key == :"ZIP Code" || key == :"ZIP + 4"}.map{ |key, value| "#{value}" }.join(", ")

    "#{address}, #{address_hash[:"ZIP Code"]}-#{address_hash[:"ZIP + 4"]}"
  end

  def self.detailed_view(index)
    binding.pry
    address_hash = self.all[index.to_i - 1]
    parsed_address(address_hash)
  end
end
