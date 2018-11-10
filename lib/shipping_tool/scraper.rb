class ShippingTool::Scraper
  include ShippingTool::User

  def validate(signature)
    Nokogiri::XML(open(signature))
  end
end
