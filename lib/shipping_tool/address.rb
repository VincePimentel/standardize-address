class ShippingTool::Address
  include ShippingTool::UI

  attr_accessor :user, :customer, :firm_name, :address_1, :address_2, :city, :state, :urbanization, :zip_5, :zip_4, :return_text

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
    self.class.reset
    #@customer = ""
    #@firm_name = ""
    #@address_1 = ""
    @address_2 = "29851 AVENTURA STE K"
    @city = "RANCHO SANTA MARGARITA"
    @state = "CA"
    #@urbanization = ""
    @zip_5 = "92688"
    @zip_4 = "9997"
    address_signature
    #Populate address with a valid one to test for user existence/validity only.
  end

  def valid_user?
    return !ShippingTool::Scraper.new.validate(user_signature).text.include?("80040B1A")
    #If response does not include the error code, "80040B1A", then user exists or is valid.
    self.class.reset
  end

  def validate_address
    ShippingTool::Scraper.new.validate(address_signature)
  end

  def save_address?

    binding.pry

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

  def display_address

  end
end
