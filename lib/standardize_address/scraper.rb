class StandardizeAddress::Scraper
  def validate(request)
    Nokogiri::XML(open(request))
  end
end
