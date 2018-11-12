class ShippingTool::AddressValidation
  include ShippingTool::User

  attr_accessor :customer, :firm_name, :address_1, :address_2, :city, :state, :urbanization, :zip_5, :zip_4, :return_text, :description

  @@all = Array.new

  def initialize(address = {})
    address.each do |key, value|
      self.send(("#{key}="), value)
    end
  end

  def self.all
    @@all
  end

  def api
    {
      host: "https://secure.shippingapis.com/ShippingAPI.dll",
      api: "Verify",
      request: "AddressValidateRequest",
    }
  end

  def address_format
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

  def signature
    "
    #{api[:host]}?API=
    #{api[:api]}&XML=<
    #{api[:request]} USERID='#{username}'>
    #{address_format.join}</
    #{api[:request]}>
    ".gsub(/\n\s+/, "")
  end

  def describe_error(number)
    message = "entered was not found."

    case number
    when "-2147219401" #AddressNotFoundError
      "Address #{message}"
    when "-2147219400" #InvalidCityError
      "City #{message}"
    when "-2147219402" #"InvalidStateError
      "State #{message}"
    else
      ""
    #when "80040b1a" #AuthorizationError
    #when "-2147219403" #MultipleAddressError
    #when "-2147218900" #InvalidImageTypeError
    end
  end

  def address
    ShippingTool::Scraper.new.validate(signature)
  end

  def valid_user?
    return !address.css("Number").text.include?("80040B1A")
  end

  def any_error?
    !address.css("Number").text.empty?
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
    address = Hash.new

    formatted_address.each do |key, value|
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

    longest_key = address.max_by { |key, value| key.length }

    address.each do |key, value|
      spacing = " " * (longest_key.first.length - key.length)
      puts "    #{key}#{spacing}: #{value}"
    end
  end

  def save(customer)
    if customer_exists?(customer)
      formatted_address.each do |key, value|
        self.class.all[customer_index][key] = value
      end
    else
      customer_address = formatted_address
      customer_address[:customer] = customer
      self.class.all << customer_address
    end
  end

  def customer_exists?(customer)
    self.class.all.any? { |addresses| addresses[:customer] == customer }
  end

  def customer_index(customer)
    if customer_exists?(customer)
      self.class.index { |addresses| addresses[:customer] == customer }
    end
  end

  def list_view
    self.class.all.each_with_index do |address, index|
      puts "#{index + 1}) #{list_view_format(address)}"
    end
  end

  def list_view_format(address)
    [
      address[:customer],
      address[:firm_name],
      address[:address_1],
      address[:address_2],
      address[:city],
      address[:state],
      address[:urbanization],
      "#{address[:zip_5]}-#{address[:zip_4]}",
    ].compact.join(", ")
  end

  def detailed_view

  end
end
