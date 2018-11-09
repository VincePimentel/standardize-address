class ShippingTool::AddressValidateRequest
  attr_accessor :user, :name, :address_1, :address_2, :city, :state, :urbanization, :zip_5, :zip_4

  def initialize(data)
    data.each do |key, value|
      self.send(("#{key}="), value)
    end
    #253VINCE6398
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
      "<Address2>#{@address_2}</Address2>",
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
    @address_2 = "29851 AVENTURA STE K"
    @city = "RANCHO SANTA MARGARITA"
    @state = "CA"
    @urbanization = ""
    @zip_5 = "92688"
    @zip_4 = "9997"
    address_signature
  end

  def user_request
    ShippingTool::AddressValidateResponse.validate(user_signature)
  end

  def valid_user?
    !user_request.text.include?("80040B1A")
    #If response does not include the error code, "80040B1A", then user is valid.
  end


  def address_signature
    #FORMAT: https://secure.shippingapis.com/ShippingAPI.dll?API=Verify&XML=<AddressValidateRequest USERID=”user_id”>DATA</AddressValidateRequest>
    "#{api[:host]}
    ?API=#{api[:api]}
    &XML=<#{api[:request]} USERID='#{@user}'>
    #{address.join}
    </#{api[:request]}>".gsub(/\n\s+/, "")
  end

  def address_request
    ShippingTool::AddressValidateResponse.validate(address_signature)
  end

  def valid_address
    {
      name: address_request.css("FirmName").text,
      address_1: address_request.css("Address1").text,
      address_2: address_request.css("Address2").text,
      city: address_request.css("City").text,
      state: address_request.css("State").text,
      urbanization: address_request.css("Urbanization").text,
      zip_5: address_request.css("Zip5").text,
      zip_4: address_request.css("Zip4").text,
      return_text: address_request.css("ReturnText").text
    }
  end

  def display_address
    valid.address.each do |key, value|

    end
  end
end
