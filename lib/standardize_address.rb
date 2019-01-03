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
      #@request.address[:name] = "John Doe"
      @request.address[:address_1] = ""
      @request.address[:address_2] = "1600 pennsylvania"
      @request.address[:city] = "washington"
      @request.address[:state] = "dc"
      @request.address[:zip_5] = "20500"
      @request.address[:zip_4] = "0003"
      verify_error_check
      #@request_1
    end

    def test_2
      #Inputs an address that does not return an error
      @request_2.name = "Jane Doe"
      @request_2.address_1 = ""
      @request_2.address_2 = "400 Broad St"
      @request_2.city = "Seattle"
      @request_2.state = "WA"
      @request_2.zip_5 = "98109"
      @request_2.zip_4 =  "4607"
      #verify_error_check
      @request_2
    end

    def test_2
      #Inputs an address that does not return an error
      @request_2.address_1 = ""
      @request_2.address_2 = "400 Broad St"
      @request_2.city = "Seattle"
      @request_2.state = "WA"
      @request_2.zip_5 = "98109"
      #verify_error_check
      @request_2
    end

    def test_4
      #Inputs an address that returns an error
      @request.address_1 = ""
      @request.address_2 = "1600 penns"
      @request.city = "wash"
      @request.state = "dc"
      @request.zip_5 = "20500"
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
