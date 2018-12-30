require "nokogiri"
require "open-uri"
require "colorize"
require "pry"

module StandardizeAddress
  module Username
    def username
      #INSERT YOUR USPS WEB TOOLS API USERNAME BETWEEN ""
      "253VINCE6398"
      #253VINCE6398
    end
  end

  module Tests
    def test_1
      #Inputs an address that does not return an error
      @address.address_1 = ""
      @address.address_2 = "1600 pennsylvania"
      @address.city = "washington"
      @address.state = "dc"
      @address.zip_5 = "20500"
      verify_error_check
    end

    def test_2
      #Inputs an address that does not return an error
      @address.address_1 = ""
      @address.address_2 = "400 Broad St"
      @address.city = "Seattle"
      @address.state = "WA"
      @address.zip_5 = "98109"
      verify_error_check
    end

    def test_3
      #Inputs an address that returns an error
      @address.address_1 = ""
      @address.address_2 = "1600 penns"
      @address.city = "wash"
      @address.state = "dc"
      @address.zip_5 = "20500"
      verify_error_check
    end
  end
end

require_relative "./standardize_address"
require_relative "./standardize_address/cli"
require_relative "./standardize_address/scraper"
require_relative "./standardize_address/address"
#require_relative "./standardize_address/package"
require_relative "./standardize_address/version"
