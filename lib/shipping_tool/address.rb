class ShippingTool::Address
  attr_accessor :user, :customer, :firm_name, :address_1, :address_2, :city, :state, :urbanization, :zip_5, :zip_4

  @@all = Array.new

  def initialize(user, data)
    @user = user
    data.each do |key, value|
      self.send(("#{key}="), value)
    end
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
  end

  # def self.reset!
  #   self.reset
  #   self.search_list.clear
  #   self.all.clear
  # end

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
    "#{api[:host]}
    ?API=#{api[:api]}
    &XML=<#{api[:request]} USERID='#{@user}'>
    #{address.join}
    </#{api[:request]}>".gsub(/\n\s+/, "")
  end

  def user_signature
    @firm_name = ""
    @address_1 = ""
    @address_2 = "29851 AVENTURA STE K"
    @city = "RANCHO SANTA MARGARITA"
    @state = "CA"
    @urbanization = ""
    @zip_5 = "92688"
    @zip_4 = "9997"
    address_signature
    #Populate address with a valid one to test for user existence/validity only.
  end

  def valid_user?
    return !ShippingTool::Scraper.new.validate(user_signature).text.include?("80040B1A")
    #If response does not include the error code, "80040B1A", then user exists or is valid.
    self.reset
  end

  def validate_address
    ShippingTool::Scraper.new.validate(address_signature)
  end

  def add_to_address_list
    valid_address = {
      customer: @customer,
      firm_name: validate_address.css("FirmName").text,
      address_1: validate_address.css("Address1").text,
      address_2: validate_address.css("Address2").text,
      city: validate_address.css("City").text,
      state: validate_address.css("State").text,
      urbanization: validate_address.css("Urbanization").text,
      zip_5: validate_address.css("Zip5").text,
      zip_4: validate_address.css("Zip4").text,
      return_text: validate_address.css("ReturnText").text
    }.delete_if { |key, value| key.nil? || value.nil? || value.empty? }

    if self.all.any? { |addresses| addresses[:customer] == @customer }
      index = self.all.index { |addresses| addresses[:customer] == @customer }
      valid_address.each do |key, value|
        self.all[index][key] = value
      end
    else
      self.all << valid_address
    end
    binding.pry
  end

  def display_address
    formatted_address = Hash.new

    self.all.last.each do |key, value|
      case k
      when :address_1
        formatted_address["Apt/Suite"] = v
      when :address_2
        formatted_address["Address"] = v
      when :zip_5
        formatted_address["ZIP Code"] = v
      when :zip_4
        formatted_address["ZIP + 4"] = v
      when :return_text
        formatted_address["Note"] = v
      else
        formatted_address[k.to_s.capitalize] = v
      end
    end

    longest_key = formatted_address.max_by { |key, value| key.length }.first

    formatted_address.each do |key, value|
      spacing = " " * (longest_key.length - key.length)
      puts "#{key}#{spacing}: #{value}"
    end
  end
end
#binding.pry
