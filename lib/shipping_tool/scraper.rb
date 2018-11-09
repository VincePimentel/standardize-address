class ShippingTool::Scraper
  HOST = "https://secure.shippingapis.com/ShippingAPI.dll?API=".freeze
  XML = "&XML=".freeze
  ID = "USERID=".freeze

  #API SIGNATURE FORMAT - <Host><API><XML><API-Request User>DATA</API-Request>

  #https://secure.shippingapis.com/ShippingAPI.dll?API=Verify&XML=<AddressValidateRequest USERID=”user_id”>DATA</AddressValidateRequest>
  L_VERIFY_API = "AddressValidateRequest".freeze
  L_VERIFY_START = "#{HOST}Verify#{XML}<#{L_VERIFY_API} #{ID}".freeze
  L_VERIFY_END = "</#{L_VERIFY_API}>".freeze

  #https://secure.shippingapis.com/ShippingAPI.dll?API=ZipCodeLookup&XML=<ZipCodeLookupRequest USERID=”userid”>DATA</ZipCodeLookupRequest>
  L_ZIP_API = "ZipCodeLookup".freeze
  L_ZIP_START = "#{HOST}#{L_ZIP_API}#{XML}<#{L_ZIP_API}Request #{ID}".freeze
  L_ZIP_END = "</#{L_ZIP_API}Request>".freeze

  #https://secure.shippingapis.com/ShippingAPI.dll?API=CityStateLookup&XML=<CityStateLookupRequest USERID=”user_id”>DATA</CityStateLookupRequest>
  L_CSTATE_API = "CityStateLookup".freeze
  L_CSTATE_START = "#{HOST}#{L_CSTATE_API}#{XML}<#{L_CSTATE_API}Request #{ID}".freeze
  L_CSTATE_END = "</#{L_CSTATE_API}Request>".freeze

  #https://secure.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=<TrackRequest USERID=”user_id”>DATA</TrackRequest>
  T_REQUEST_API = "TrackRequest".freeze
  T_REQUEST_START = "#{HOST}TrackV2#{XML}<#{T_REQUEST_API} #{ID}".freeze
  T_REQUEST_END = "</#{T_REQUEST_API}>".freeze

  #https://secure.shippingapis.com/ShippingAPI.dll?API=TrackV2&XML=<TrackFieldRequest USERID=”user_id”>DATA</TrackFieldRequest>
  T_FIELD_API = "TrackField".freeze
  T_FIELD_START = "#{HOST}TrackV2#{XML}<#{T_FIELD_API}Request #{ID}".freeze
  T_FIELD_END = "</#{T_FIELD_API}Request>".freeze

  #https://secure.shippingapis.com/ShippingAPI.dll?API=PTSEmail&XML=<PTSEmailRequest USERID=”user_id”>DATA</PTSEmailRequest>
  T_EMAIL_API = "PTSEmail".freeze
  T_EMAIL_START = "#{HOST}#{T_EMAIL_API}#{XML}<#{T_EMAIL_API}Request #{ID}".freeze
  T_EMAIL_END = "</#{T_EMAIL_API}Request>".freeze

  attr_accessor :user_id

  def initialize(user_id)
    @user_id = user_id
  end

  def valid_user?(user)

  end

  def verify(address)
    Nokogiri::XML(open("#{L_VERIFY_START}'#{@user_id}'>#{address}#{L_VERIFY_END}"))
  end
end
