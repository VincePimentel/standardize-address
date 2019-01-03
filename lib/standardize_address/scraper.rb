class StandardizeAddress::Scraper
  include StandardizeAddress::Username

  attr_reader :address

  def initialize(address_hash = {})
    @address = address_hash
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
      "<Address1>#{@address[:address_1]}</Address1>",
      "<Address2>#{@address[:address_2]}</Address2>",
      "<City>#{@address[:city]}</City>",
      "<State>#{@address[:state]}</State>",
      "<Zip5>#{@address[:zip_5]}</Zip5>",
      "<Zip4></Zip4>",
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

  def valid?
    !xml_response.css("Number").text.include?("80040B1A")
  end

  def any_error?
    !xml_response.css("Number").text.empty?
  end

  def error_code
    xml_response.css("Number").text
  end

  def hash_response
    xml = xml_response
    {
      address_1: xml.css("Address1").text,
      address_2: xml.css("Address2").text,
      city: xml.css("City").text,
      state: xml.css("State").text,
      zip_5: xml.css("Zip5").text,
      zip_4: xml.css("Zip4").text,
      return_text: xml.css("ReturnText").text,
      number: xml.css("Number").text
    }.reject{ |key, value| value.to_s.empty? }
  end

  def formatted_response
    hash = hash_response
    {
      "Apt/Suite": hash[:address_1],
      "Street": hash[:address_2],
      "City": hash[:city],
      "State": hash[:state],
      "ZIP Code": hash[:zip_5],
      "ZIP + 4": hash[:zip_4],
      "Note": hash[:return_text].split(": ")[1]
    }.reject{ |key, value| value.to_s.empty? }
  end

  # def create_new_address
  #   StandardizeAddress::Address.new(address_hash)
  # end
end
