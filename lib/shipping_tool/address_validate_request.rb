class ShippingTool::AddressValidateRequest
  attr_accessor :user

  def initialize(user)
    @user = user
    #253VINCE6398
  end

  def api
    {
      host: "https://secure.shippingapis.com/ShippingAPI.dll",
      api: "Verify",
      request: "AddressValidateRequest",
    }
  end

  def address(name: "", address_1: "", address_2: "", city: "", state: "", urbanization: "", zip_5: "", zip_4: "")
    [
      "<Address ID='0'>",
      "<FirmName>#{name}</FirmName>",
      "<Address1>#{address_1}</Address1>",
      "<Address2>#{address_2}</Address2>",
      "<City>#{city}</City>",
      "<State>#{state}</State>",
      "<Urbanization>#{urbanization}</Urbanization>",
      "<Zip5>#{zip_5}</Zip5>",
      "<Zip4>#{zip_4}</Zip4>",
      "</Address>"
    ]
  end

  #https://secure.shippingapis.com/ShippingAPI.dll?API=Verify&XML=<AddressValidateRequest USERID=”user_id”>DATA</AddressValidateRequest>
  def format
    "#{self.api[:host]}
    ?API=#{self.api[:api]}
    &XML=<#{self.api[:request]} USERID='#{@user}'>
    #{address.join}
    </#{self.api[:request]}>".gsub(/\n\s+/, "")
  end
end

binding.pry
