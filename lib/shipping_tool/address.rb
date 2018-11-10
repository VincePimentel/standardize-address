class ShippingTool::AddressValidation
  include ShippingTool::UI

  attr_accessor :user, :customer, :firm_name, :address_1, :address_2, :city, :state, :urbanization, :zip_5, :zip_4, :return_text, :description

  @@all = Array.new

  def initialize(user, address = {})
    @user = user
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

  def address_signature
    "
    #{api[:host]}?API=
    #{api[:api]}&XML=<
    #{api[:request]} USERID='#{@user}'>
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
    address_signature
    #self.class.reset
    #Populate address with a valid one to test for user existence/validity only.
  end

  def valid_user?
    return !ShippingTool::Scraper.new.validate(user_signature).text.include?("80040B1A")
    #If response does not include the error code, "80040B1A", then user exists or is valid.
  end

  def validate
    ShippingTool::Scraper.new.validate(address_signature)
  end

  def parse_address
    {
      #customer: @customer,
      firm_name: validate.css("FirmName").text,
      address_1: validate.css("Address1").text,
      address_2: validate.css("Address2").text,
      city: validate.css("City").text,
      state: validate.css("State").text,
      urbanization: validate.css("Urbanization").text,
      zip_5: validate.css("Zip5").text,
      zip_4: validate.css("Zip4").text,
      return_text: validate.css("ReturnText").text,
      description: validate.css("Description").text
    }.delete_if { |key, value| value.empty? }
  end

  def display_address
    address = Hash.new

    parse_address.each do |key, value|
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
      puts "#{key}#{spacing}: #{value}"
    end
    binding.pry
  end

  def save_address?

    #binding.pry

    # validated_address.each do |key, value|
    #   self.send(("#{key}="), value)
    # end

    # self.class.all << validated_address
    # if @@all.any? { |addresses| addresses[:customer] == @customer }
    #   index = @@all.index { |addresses| addresses[:customer] == @customer }
    #   validated_address.each do |key, value|
    #     @@all[index][key] = value
    #   end
    # else
    #   @@all << validated_address
    # end
  end
end
