class StandardizeAddress::Scraper
  include StandardizeAddress::Username

  attr_accessor :addressee, :address_1, :address_2, :city, :state, :zip_5, :zip_4, :return_text, :number

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

  def xml_tags
    [
      "<Address ID='0'>",
      "<Address1>#{self.address_1}</Address1>",
      "<Address2>#{self.address_2}</Address2>",
      "<City>#{self.city}</City>",
      "<State>#{self.state}</State>",
      "<Zip5>#{self.zip_5}</Zip5>",
      "<Zip4>#{self.zip_4}</Zip4>",
      "</Address>"
    ]
  end

  def xml_request
    "
    #{signature[:host]}
    #{signature[:api]}
    #{signature[:name]}
    #{signature[:xml]}
    <#{signature[:request]} #{signature[:user]}>
    #{xml_tags.join}
    </#{signature[:request]}>
    ".gsub(/\n\s+/, "")
  end

  def xml_response
    Nokogiri::XML(open(xml_request))
  end

  def set_attributes
    xml = xml_response
    self.address_1 = xml.css("Address1").text
    self.address_2 = xml.css("Address2").text
    self.city = xml.css("City").text
    self.state = xml.css("State").text
    self.zip_5 = xml.css("Zip5").text
    self.zip_4 = xml.css("Zip4").text
    self.return_text = xml.css("ReturnText").text
    self.number = xml.css("Number").text
    self
  end

  def valid?
    !self.number.include?("80040B1A")
  end

  def any_error?
    !self.number.empty?
  end

end
