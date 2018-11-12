class ShippingTool::CLI
  include ShippingTool::User, ShippingTool::UI, ShippingTool::Navigation

  def validate_username
    address = {
      address_2: "29851 AVENTURA STE K",
      city: "RANCHO SANTA MARGARITA",
      state: "CA",
      zip_5: "92688",
      zip_4: "9997"
    }

    user_check = ShippingTool::AddressValidation.new(address).valid_user?

    if user_check
      start
    else
      if username.empty?
        puts "Please make sure that you have saved your USPS Web Tools API Username inside /lib/shipping_tool.rb."
        spacer
        puts "To request a username, please visit:"
        puts "https://www.usps.com/business/web-tools-apis/web-tools-registration.htm"
      elsif !username.empty? && !user_check
        puts "Username is incorrect or does not exist. Please double check your username inside /lib/shipping_tool.rb."
      end
    end
  end

  def start
    @current_menu = "start"
    menu_options = ["VERIFY", "ADDRESSES", "EXIT", "TEST1", "TEST2"]
    option = "!"
    until option_check(option, menu_options)
      banner("ADDRESS STANDARDIZATION AND PACKAGE TRACKING")
      puts "What would you like to do today?"
      spacer
      puts "    verify   : Standardize an address."
      puts "    addresses: Displays all previous address searches."
      #puts "    track    : Track package status."
      #puts "    packages : Displays all previous package tracks."
      puts "    exit     : Terminates the program."
      spacer
      option = gets.strip.upcase
    end

    case option
    when "VERIFY" then verify
    when "ADDRESSES" then addresses
    #when "TRACK" then track
    #when "PACKAGES" then packages
    when "EXIT" then exit

    #Test cases
    when "TEST1" then test1
    when "TEST2" then test2
    end
  end

  def test1
    @address_2 = "8820 Washington Blvd"
    @city = "Culver"
    @state = "CA"
    @zip_5 = "90232"
    verify_request
  end

  def test2
    @address_2 = "29851 AVENTUR"
    @city = "RANCHO SANTA"
    @state = "CA"
    @zip_5 = "92688"
    verify_request
  end

  def test3
    @address_2 = "29851"
    @city = "RANCHO SANTA"
    @state = "CA"
    @zip_5 = "926"
    verify_request
  end

  def verify
    @current_menu = "verify"
    banner("ADDRESS STANDARDIZATION TOOL")
    puts "Corrects errors in street addresses including abbreviations and missing information and supplies ZIP Codes and ZIP Codes + 4."
    spacer
    puts "To begin, please fill out the following:"
    spacer

    print "Apartment/Suite number: "
    @address_1 = gets.strip.upcase
    spacer

    @address_2 = ""
    until !@address_2.empty?
      print "Street address (required): "
      @address_2 = gets.strip.upcase
      spacer
    end

    print "Enter the City: "
    @city = gets.strip.upcase
    spacer

    print "Enter the State: "
    @state = gets.strip.upcase
    spacer

    print "Enter the ZIP code: "
    @zip_5 = gets.strip.upcase
    spacer

    menu_options = ["Y", "", "N"]
    option = "!"
    until option_check(option, menu_options)
      banner("Is this correct? (y/n)")
      puts "    Apt/Suite: #{@address_1}"
      puts "    Address  : #{@address_2}"
      puts "    City     : #{@city}"
      puts "    State    : #{@state}"
      puts "    ZIP Code : #{@zip_5}"
      spacer
      option = gets.strip.upcase
    end

    case option
    when "Y", "" then verify_request
    when "N" then verify
    end
  end

  def verify_request
    address = {
      address_1: @address_1,
      address_2: @address_2,
      city: @city,
      state: @state,
      zip_5: @zip_5
    }

    request = ShippingTool::AddressValidation.new(address)

    a = request.parsed_response
    b = request.display_response
    c = request.save_response("Vince")
    binding.pry

  end

  def verify_display_results
    banner("STANDARDIZED ADDRESS")

    menu_options = ["Y", "", "N"]
    option = "!"
    until option_check(option, menu_options)

      spacer

      puts "Do you want to save this address? (y/n)"
      spacer

      option = gets.strip.upcase
    end
    spacer

    i = 3
    case option
    when "Y", ""
      puts "Please enter a name to save this address under:"
      customer = gets.strip.split(/(\W)/).map(&:capitalize).join
      #titleize customer name
      request.save_address(customer)
      spacer

      banner("ADDRESS SAVED UNDER: #{customer}")

      until i == 0
        puts "Returning to main menu in #{i}."
        sleep 1
        i -= 1
      end
    when "N"
      banner("ADDRESS NOT SAVED")

      until i == 0
        puts "Returning to main menu in #{i}."
        sleep 1
        i -= 1
      end
    end

    start
  end

  def back
    case @current_menu
    when "verify" then start
    end
  end
end
