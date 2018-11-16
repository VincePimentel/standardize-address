class StandardizeAddress::Verify
  include StandardizeAddress::Username

  attr_accessor :customer, :firm_name, :address_1, :address_2, :city, :state, :urbanization, :zip_5, :zip_4, :return_text, :description

  @@all = Array.new

  def initialize(address_hash = {})
    address_hash.each do |key, value|
      self.send(("#{key}="), value)
    end
  end

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
      "<FirmName>#{@firm_name}</FirmName>",
      "<Address1>#{@address_1}</Address1>",
      "<Address2>#{@address_2}</Address2>",
      "<City>#{@city}</City>",
      "<State>#{@state}</State>",
      "<Urbanization>#{@urbanization}</Urbanization>",
      "<Zip5>#{@zip_5}</Zip5>",
      "<Zip4>#{@zip_4}</Zip4>",
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

  def describe_error(number)
    message = "entered was not found."

    case number
    when "-2147219401"
      "Address #{message}"
    when "-2147219400"
      "City #{message}"
    when "-2147219402"
      "State #{message}"
    else
      ""
    end
  end

  def address
    StandardizeAddress::Scraper.new.validate(request)
  end

  def valid_user?
    !address.css("Number").text.include?("80040B1A")
  end

  def any_error?
    !address.css("Number").text.empty?
  end

  def parsed_address(address_hash)
    address = Hash.new

    address_hash.each do |key, value|
      case key
      when :firm_name
        address["Company"] = value
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

  def formatted_address
    {
      firm_name: address.css("FirmName").text,
      address_1: address.css("Address1").text,
      address_2: address.css("Address2").text,
      city: address.css("City").text,
      state: address.css("State").text,
      urbanization: address.css("Urbanization").text,
      zip_5: address.css("Zip5").text,
      zip_4: address.css("Zip4").text,
      return_text: address.css("ReturnText").text,
      description: describe_error(address.css("Number").text)
    }.delete_if { |key, value| value.empty? || value.nil? }
  end

  def display
    parsed_address(formatted_address)
  end

  def save(customer)
    customer_address = formatted_address

    customer_address.delete_if do |key, value|
      value.empty? || value.nil? || key == :return_text || key == :description
    end

    if customer_exists?(customer)
      customer_address.each do |key, value|
        self.class.all[customer_index(customer)][key] = value
      end
    else
      customer_address[:customer] = customer
      self.class.all << customer_address
    end
  end

  def customer_exists?(customer)
    self.class.all.any? { |addresses| addresses[:customer] == customer }
  end

  def customer_index(customer)
    if customer_exists?(customer)
      self.class.all.index { |addresses| addresses[:customer] == customer }
    end
  end

  def list_view
    self.class.all.each_with_index do |address, index|
      puts "#{index + 1}) #{list_view_format(address)}"
    end
  end

  def list_view_format(address_hash)
    [
      address_hash[:customer],
      address_hash[:firm_name],
      address_hash[:address_1],
      address_hash[:address_2],
      address_hash[:city],
      address_hash[:state],
      address_hash[:urbanization],
      "#{address_hash[:zip_5]}-#{address_hash[:zip_4]}"
    ].compact.reject(&:empty?).join(", ")
  end

  def detailed_view(index)
    address_hash = self.class.all[index.to_i - 1]
    parsed_address(address_hash)
  end
end
