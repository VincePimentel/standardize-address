class StandardizeAddress::Address



  @@all = Array.new

  def self.all
    @@all
  end





  # def parsed_address(address_hash)
  #   address = Hash.new
  #
  #   address_hash.each do |key, value|
  #     case key
  #     when :address_1
  #       address["Apt/Suite"] = value
  #     when :address_2
  #       address["Address"] = value
  #     when :zip_5
  #       address["ZIP Code"] = value
  #     when :zip_4
  #       address["ZIP + 4"] = value
  #     when :return_text
  #       address["Note"] = value
  #     when :description
  #       address["Error"] = value
  #     else
  #       address[key.to_s.capitalize] = value
  #     end
  #   end
  #
  #   address.each do |key, value|
  #     spacing = " " * (longest_key(address_hash).first.length - key.length)
  #     if key == "Error"
  #       puts "    #{key}: #{value}"
  #     else
  #       puts "    #{key}#{spacing}: #{value}"
  #     end
  #   end
  # end

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
