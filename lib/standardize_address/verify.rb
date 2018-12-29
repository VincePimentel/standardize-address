class StandardizeAddress::Verify
  include StandardizeAddress::Username

  attr_accessor :addressee, :address_1, :address_2, :city, :state, :zip_5, :zip_4, :return_text, :number

  @@all = Array.new

  # def initialize(address_hash = {})
  #   address_hash.each do |key, value|
  #     self.send("#{key}=", value)
  #   end
  # end

  def self.all
    @@all
  end

  def signature
    {
      host: "https://secure.shippingapis.com/ShippingAPI.dll",
      api: "?API=",
      name: "Verify",
      xml: "&XML=",
      request: "AddressValidateRequest",
      user: "USERID='#{username}'"
      #username found in standardized_address.rb
    }
  end

  def xml_request
    [
      "<Address ID='0'>",
      "<Address1>#{self.address_1}</Address1>",
      "<Address2>#{self.address_2}</Address2>",
      "<City>#{self.city}</City>",
      "<State>#{self.state}</State>",
      "<Zip5>#{self.zip_5}</Zip5>",
      "<Zip4>#{self.zip_4}</Zip4>",
      "</Address>"
    ]
  end

  def request
    "
    #{signature[:host]}
    #{signature[:api]}
    #{signature[:name]}
    #{signature[:xml]}
    <#{signature[:request]} #{signature[:user]}>
    #{xml_request.join}
    </#{signature[:request]}>
    ".gsub(/\n\s+/, "")
  end

  def address
    StandardizeAddress::Scraper.new.validate(request)
  end

  def set_attributes
    self.address_1 = address.css("Address1").text
    self.address_2 = address.css("Address2").text
    self.city = address.css("City").text
    self.state = address.css("State").text
    self.zip_5 = address.css("Zip5").text
    self.zip_4 = address.css("Zip4").text
    self.return_text = address.css("ReturnText").text
    self.number = address.css("Number").text
  end

  def formatted_address
    {
      address_1: address.css("Address1").text,
      address_2: address.css("Address2").text,
      city: address.css("City").text,
      state: address.css("State").text,
      zip_5: address.css("Zip5").text,
      zip_4: address.css("Zip4").text,
      return_text: address.css("ReturnText").text,
      number: address.css("Number").text
    }.delete_if { |key, value| value.empty? || value.nil? }
  end

  def valid?
    !self.number.include?("80040B1A")
  end

  def any_error?
    !self.number.empty?
  end

  def parsed_address(address_hash)
    address = Hash.new

    address_hash.each do |key, value|
      case key
      when :address_1
        address["Apt/Suite"] = value
      when :address_2
        address["Address"] = value
      when :zip_5
        address["ZIP Code"] = value
      when :zip_4
        address["ZIP + 4"] = value
      when :return_text
        address["Note"] = value
      when :description
        address["Error"] = value
      else
        address[key.to_s.capitalize] = value
      end
    end

    address.each do |key, value|
      spacing = " " * (longest_key(address_hash).first.length - key.length)
      if key == "Error"
        puts "    #{key}: #{value}"
      else
        puts "    #{key}#{spacing}: #{value}"
      end
    end
  end

  def longest_key(address_hash)
    address_hash.max_by { |key, value| key.length }
  end

  def display
    parsed_address(formatted_address)
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
