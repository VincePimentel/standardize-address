class StandardizeAddress::Address



  @@all = Array.new

  def self.all
    @@all
  end


  def save(addressee)
    addressee_address = formatted_address

    addressee_address.delete_if do |key, value|
      value.empty? || value.nil? || key == :return_text || key == :description
    end

    if addressee_exists?(addressee)
      addressee_address.each do |key, value|
        self.class.all[addressee_index(addressee)][key] = value
      end
    else
      addressee_address[:addressee] = addressee
      self.class.all << addressee_address
    end
  end

  def addressee_exists?(addressee)
    self.class.all.any? { |addresses| addresses[:addressee] == addressee }
  end

  def addressee_index(addressee)
    if addressee_exists?(addressee)
      self.class.all.index { |addresses| addresses[:addressee] == addressee }
    end
  end

  def list_view
    self.class.all.each_with_index do |address, index|
      puts "#{index + 1}) #{list_view_format(address)}"
    end
  end

  def list_view_format(address_hash)
    [
      address_hash[:addressee],
      address_hash[:address_1],
      address_hash[:address_2],
      address_hash[:city],
      address_hash[:state],
      "#{address_hash[:zip_5]}-#{address_hash[:zip_4]}"
    ].compact.reject(&:empty?).join(", ")
  end

  def detailed_view(index)
    address_hash = self.class.all[index.to_i - 1]
    parsed_address(address_hash)
  end
end
