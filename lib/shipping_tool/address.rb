class ShippingTool::AddressValidation
  include ShippingTool::User, ShippingTool::UI

  attr_accessor :customer, :firm_name, :address_1, :address_2, :city, :state, :urbanization, :zip_5, :zip_4, :return_text, :description

  @@all = Array.new

  def initialize(address = {})
    address.each do |key, value|
      self.send(("#{key}="), value)
    end
    #@@all << self
  end

  def self.all
    @@all
  end

  def self.reset
    @customer = ""
    @firm_name = ""
    @address_1 = ""
    @address_2 = ""
    @city = ""
    @state = ""
    @urbanization = ""
    @zip_5 = ""
    @zip_4 = ""
    @return_text = ""
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

  def user_signature
    #self.class.reset
    @address_2 = "29851 AVENTURA STE K"
    @city = "RANCHO SANTA MARGARITA"
    @state = "CA"
    @zip_5 = "92688"
    @zip_4 = "9997"
    signature
    #self.class.reset
  end

  def valid_user?
    return !ShippingTool::Scraper.new.validate(user_signature).text.include?("80040B1A")
  end

  def validated_address
    ShippingTool::Scraper.new.validate(signature)
  end

  def parsed_address
    {
      firm_name: validated_address.css("FirmName").text,
      address_1: validated_address.css("Address1").text,
      address_2: validated_address.css("Address2").text,
      city: validated_address.css("City").text,
      state: validated_address.css("State").text,
      urbanization: validated_address.css("Urbanization").text,
      zip_5: validated_address.css("Zip5").text,
      zip_4: validated_address.css("Zip4").text,
      return_text: validated_address.css("ReturnText").text,
      description: validated_address.css("Description").text
    }.delete_if { |key, value| value.empty? }
  end

  def display_address
    address = Hash.new

    parsed_address.each do |key, value|
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

  def save_address(customer)
    if self.class.any? { |addresses| addresses[:customer] == customer }
      i = self.class.index { |addresses| addresses[:customer] == customer }
      parsed_address.each do |key, value|
        self.class.all[i][key] = value
      end
    else
      self.class.all << parsed_address
    end
  end
end
