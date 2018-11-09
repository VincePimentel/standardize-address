class ShippingTool::AddressValidateResponse
  def validate(signature)
    Nokogiri::XML(open(signature))
  end
end
