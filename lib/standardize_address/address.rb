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

    if addressee_exists?
      @address.each do |key, value|
        self.class.all[addressee_index][key] = value
      end
    else
      #@address[:"Name"] = @address[:"Name"]
      self.class.all << @address
    end
  end

  def addressee_exists?
    self.class.all.any? { |address| address[:"Name"] == @address[:"Name"] }
  end

  def addressee_index
    if addressee_exists?
      self.class.all.index { |address| address[:"Name"] == @address[:"Name"] }
    end
  end

  def list_view
    self.class.all.each_with_index do |address, index|
      puts "#{index + 1}) #{list_view_format(address)}"
    end
  end

  def list_view_format(address_hash)
    address_hash.map { |key, value| "#{value}" }.compact.reject(&:empty?).join(", ") + "#{address_hash[:"ZIP Code"]}-#{address_hash[:"ZIP + 4"]}"
    binding.pry
  end

  def detailed_view(index)
    address_hash = self.class.all[index.to_i - 1]
    parsed_address(address_hash)
  end
end
