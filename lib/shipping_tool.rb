module ShippingTool
  module User
    def username
      #ENTER YOUR USPS WEB TOOLS API USERNAME BELOW AS A STRING (" ")
      "253VINCE6398"
    end
  end

  module InstanceMethods
    def reset
      @customer = nil
      @firm_name = nil
      @address_1 = nil
      @address_2 = nil
      @city = nil
      @state = nil
      @urbanization = nil
      @zip_5 = nil
      @zip_4 = nil
      @return_text = nil
      @description = nil
    end
  end

  module UI
    def option_check(option, menu_options)
      !([option] & menu_options).empty?
      #Tests to see if user input is a menu option.
    end

    def exit
      spacer
      puts "Goodbye! Have a nice day!"
      spacer
    end

    def banner(message)
      spacer
      border(message.length)
      puts message
      border(message.length)
      spacer
    end

    def spacer
      puts ""
    end

    def border(length = 1)
      puts "=" * length
    end

    def full_border_spacer(length = 1)
      spacer
      border(length)
      spacer
    end
  end

  module Test
    def valid_address
      {
        address_2: "29851 AVENTURA STE K",
        city: "RANCHO SANTA MARGARITA",
        state: "CA",
        zip_5: "92688",
        zip_4: "9997"
      }
    end

    def test_0
      #Generate multiple addresses
      i = 1
      2.times do
        address = ShippingTool::AddressValidation.new(valid_address)
        address.save("John Doe ##{i}")
        i += 1
      end

      binding.pry
    end

    def test_1
      @address_2 = "8820 Washington Blvd"
      @city = "Culver"
      @state = "CA"
      @zip_5 = "90232"
      verify_error_check
    end

    def test_2
      @address_2 = "29851 AVENTUR"
      @city = "RANCHO SANTA"
      @state = "CA"
      @zip_5 = "92688"
      verify_error_check
    end

    def test_3
      @address_2 = "29851"
      @city = "RANCHO SANTA"
      @state = "CA"
      @zip_5 = "926"
      verify_error_check
    end
  end
end

require_relative "../config/environment"
