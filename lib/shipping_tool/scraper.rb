class ShippingTool::Scraper
  def validate(signature)
    Nokogiri::XML(open(signature))
  end
end
