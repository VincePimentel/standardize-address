module StandardizeAddress
  module Username
    def username
      #ENTER YOUR USPS WEB TOOLS API USERNAME BELOW AS A STRING (" ")
      "253VINCE6398"
    end
  end

  module Test
    def test_address_0
      {
        address_2: "29851 AVENTURA STE K",
        city: "RANCHO SANTA MARGARITA",
        state: "CA",
        zip_5: "92688",
        zip_4: "9997"
      }
    end

    def test_address_1
      {
        address_1: "101",
        address_2: "8820 Washington Blvd",
        city: "Culver",
        state: "CA",
        zip_5: "90232"
      }
    end

    def test_address_2
      {
        address_2: "7000 Coliseum Way",
        city: "Oakland",
        state: "CA",
        zip_5: "94621"
      }
    end

    def test_address_3
      {
        address_2: "29851",
        city: "RANCHO SANTA",
        state: "CA",
        zip_5: "926"
      }
    end

    def test_0
      address_test_1 = StandardizeAddress::Verify.new(test_address_1)
      address_test_1.save("John Doe #1")
      address_test_2 = StandardizeAddress::Verify.new(test_address_2)
      address_test_2.save("John Doe #2")
      menu
    end

    def test_1
      verify_error_check(test_address_1)
    end

    def test_2
      verify_error_check(test_address_2)
    end

    def test_3
      verify_error_check(test_address_3)
    end
  end
end

require_relative "../config/environment"
