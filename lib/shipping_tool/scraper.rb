class ShippingTool::Scraper
  def validate(signature)
    Nokogiri::XML(open(signature))
  end

  def parse
    {
      customer: @customer,
      firm_name: validate.css("FirmName").text,
      address_1: validate.css("Address1").text,
      address_2: validate.css("Address2").text,
      city: validate.css("City").text,
      state: validate.css("State").text,
      urbanization: validate.css("Urbanization").text,
      zip_5: validate.css("Zip5").text,
      zip_4: validate.css("Zip4").text,
      return_text: validate.css("ReturnText").text
    }.delete_if { |key, value| value.empty? }
  end

  def format
    address = Hash.new

    parse.each do |key, value|
      case key
      when :address_1
        address["Apt/Suite"] = value
      when :address_2
        address["Address"] = value
      when :zip_5
        address["ZIP Code"] = value
      when :zip_4
        address["ZIP + 4"] = value
      when :return_text
        address["Note"] = value
      else
        address[key.to_s.capitalize] = value
      end
    end

    longest_key = address.max_by { |key, value| key.length }.first

    address.each do |key, value|
      spacing = " " * (longest_key.length - key.length)
      puts "#{key}#{spacing}: #{value}"
    end
  end
end
