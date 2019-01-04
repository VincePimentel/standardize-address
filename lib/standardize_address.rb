require "nokogiri"
require "open-uri"
require "colorize"
require "pry"

module StandardizeAddress
  module Username
    def username
      #INSERT YOUR USERNAME BETWEEN "" BELOW
      ""
      #INSERT YOUR USERNAME BETWEEN "" ABOVE
    end
  end

  module Tests
    def test_1
      @request.address_1 = ""
      @request.address_2 = "1600 pennsylvania"
      @request.city = "washington"
      @request.state = "dc"
      @request.zip_5 = "20500"
      error_check
    end

    def test_2
      @request.address_1 = ""
      @request.address_2 = "400 Broad St"
      @request.city = "Seattle"
      @request.state = "WA"
      @request.zip_5 = "98109"
      error_check
    end

    def test_3
      @request.address_1 = ""
      @request.address_2 = "1600 penns"
      @request.city = "wash"
      @request.state = "dc"
      @request.zip_5 = "20500"
      error_check
    end
  end
end

require_relative "./standardize_address"
require_relative "./standardize_address/cli"
require_relative "./standardize_address/scraper"
require_relative "./standardize_address/address"
#require_relative "./standardize_address/package"
require_relative "./standardize_address/version"
