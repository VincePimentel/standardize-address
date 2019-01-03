class StandardizeAddress::Scraper
  include StandardizeAddress::Username

  # attr_accessor :address_1, :address_2, :city, :state, :zip_5, :zip_4, :return_text, :number

  attr_reader :address

  def initialize(address = nil)
    @address = address
    binding.pry
  end

  def signature
    {
      host: "https://secure.shippingapis.com/ShippingAPI.dll",
      api: "?API=",
      name: "Verify",
      xml: "&XML=",
      request: "AddressValidateRequest",
      user: "USERID='#{username}'"
      #username found in lib/standardized_address.rb
    }
  end

  def xml_tags
    [
      "<Address ID='0'>",
      "<Address1>#{address.address_1}</Address1>",
      "<Address2>#{address.address_2}</Address2>",
      "<City>#{address.city}</City>",
      "<State>#{address.state}</State>",
      "<Zip5>#{address.zip_5}</Zip5>",
      "<Zip4>#{address.zip_4}</Zip4>",
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
    address.address_1 = xml.css("Address1").text
    address.address_2 = xml.css("Address2").text
    address.city = xml.css("City").text
    address.state = xml.css("State").text
    address.zip_5 = xml.css("Zip5").text
    address.zip_4 = xml.css("Zip4").text
    address.return_text = xml.css("ReturnText").text
    address.number = xml.css("Number").text
    address
  end

  def valid?
    !address.number.include?("80040B1A")
  end

  def any_error?
    !address.number.empty?
  end
end
