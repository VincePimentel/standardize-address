class ShippingTool::AddressValidateRequest
  attr_accessor :user, :name, :address_1, :address, :city, :state, :urbanization, :zip_5, :zip_4

  @@all = Array.new

  def initialize(data)
    data.each do |key, value|
      self.send(("#{key}="), value)
    end
    #253VINCE6398
  end

  def self.all
    @@all
  end

  def self.reset
    @name = ""
    @address_1 = ""
    @address = ""
    @city = ""
    @state = ""
    @urbanization = ""
    @zip_5 = ""
    @zip_4 = ""
  end

  def self.reset!
    self.reset
    self.all.clear
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
      "<FirmName>#{@name}</FirmName>",
      "<Address1>#{@address_1}</Address1>",
      "<Address2>#{@address}</Address2>",
      "<City>#{@city}</City>",
      "<State>#{@state}</State>",
      "<Urbanization>#{@urbanization}</Urbanization>",
      "<Zip5>#{@zip_5}</Zip5>",
      "<Zip4>#{@zip_4}</Zip4>",
      "</Address>"
    ]
  end

  def user_signature
    @name = ""
    @address_1 = ""
    @address = "29851 AVENTURA STE K"
    @city = "RANCHO SANTA MARGARITA"
    @state = "CA"
    @urbanization = ""
    @zip_5 = "92688"
    @zip_4 = "9997"
    address_signature
    #Populate address request with a valid address to test for user existence only.
  end

  def valid_user?
    !ShippingTool::AddressValidateResponse.new.validate(user_signature).text.include?("80040B1A")
    #If response does not include the error code, "80040B1A", then user is valid.
    self.reset
  end


  def address_signature
    #FORMAT GUIDE:
    #https://secure.shippingapis.com/ShippingAPI.dll
    #?API=Verify
    #&XML=<AddressValidateRequest USERID=”user_id”>
    #ADDRESS
    #</AddressValidateRequest>
    "#{api[:host]}
    ?API=#{api[:api]}
    &XML=<#{api[:request]} USERID='#{@user}'>
    #{address.join}
    </#{api[:request]}>".gsub(/\n\s+/, "")
  end

  def validate_address
    request = ShippingTool::AddressValidateResponse.new.validate(address_signature)
    self.all << {
      name: request.css("FirmName").text,
      address_1: request.css("Address1").text,
      address: request.css("Address2").text,
      city: request.css("City").text,
      state: request.css("State").text,
      urbanization: request.css("Urbanization").text,
      zip_5: request.css("Zip5").text,
      zip_4: request.css("Zip4").text,
      return_text: request.css("ReturnText").text
    }
  end

  def display_address
    self.all.last.select { |key, value| !value.empty? }.each do |key, value|
      key = key.to_s.gsub("_", " ").capitalize
      case key
      when "Address 1"
        key = "Apt/Suite"
      when "Zip 5"
        key = "ZIP Code"
      when "Zip 4"
        key = "ZIP + 4"
      when "Return text"
        key = "Note"
      end
      puts "#{key}: #{value}"
    end
  end
end
