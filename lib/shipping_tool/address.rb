class ShippingTool::AddressValidation
  include ShippingTool::User, ShippingTool::UI

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

  def address
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
    #{address.join}</
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

  def response
    ShippingTool::Scraper.new.validate(signature)
  end

  def valid_user?
    return !response.css("Number").text.include?("80040B1A")
  end

  def any_error?
    !response.css("Number").text.empty?
  end

  def formatted_response
    {
      firm_name: response.css("FirmName").text,
      address_1: response.css("Address1").text,
      address_2: response.css("Address2").text,
      city: response.css("City").text,
      state: response.css("State").text,
      urbanization: response.css("Urbanization").text,
      zip_5: response.css("Zip5").text,
      zip_4: response.css("Zip4").text,
      return_text: response.css("ReturnText").text,
      description: describe_error(response.css("Number").text)
    }.delete_if { |key, value| value.empty? || value.nil? }
  end

  def display_response
    address = Hash.new

    formatted_response.each do |key, value|
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

  def save_response(customer)
    if self.class.all.any? { |addresses| addresses[:customer] == customer }
      formatted_response.each do |key, value|
        i = self.class.index { |addresses| addresses[:customer] == customer }
        self.class.all[i][key] = value
      end
    else
      self.class.all << formatted_response
    end
  end
end
