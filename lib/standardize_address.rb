require "nokogiri"
require "open-uri"
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
      @session.address_1 = ""
      @session.address_2 = "1600 pennsylvania"
      @session.city = "washington"
      @session.state = "dc"
      @session.zip_5 = "20500"
      verify_error_check
    end

    def test_2
      @session.address_1 = ""
      @session.address_2 = "1600 penns"
      @session.city = "wash"
      @session.state = "dc"
      @session.zip_5 = "20500"
      verify_error_check
    end
  end
end

require_relative "./standardize_address"
require_relative "./standardize_address/cli"
require_relative "./standardize_address/address"
require_relative "./standardize_address/verify"
require_relative "./standardize_address/scraper"
require_relative "./standardize_address/version"
