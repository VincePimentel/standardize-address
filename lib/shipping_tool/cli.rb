class ShippingTool::CLI
  include ShippingTool::User, ShippingTool::UI

  def validate_username
    if ShippingTool::AddressValidation.new.valid_user?
      start
    else
      if username.empty?
        puts "Please make sure that you have saved your USPS Web Tools API Username inside /lib/shipping_tool.rb."
        spacer
        puts "To request a username, please visit:"
        puts "https://www.usps.com/business/web-tools-apis/web-tools-registration.htm"
      elsif !username.empty? && !ShippingTool::AddressValidation.new.valid_user?
        puts "Username is incorrect or does not exist. Please double check your username inside /lib/shipping_tool.rb."
      end
    end
  end

  def start
    @current_menu = "start"
    option = ""
    until option == "VERIFY" || option == "ADDRESSES" || option == "TEST1" || option == "TEST2" || option == "EXIT"
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
    when "TEST1" then test1
    when "TEST2" then test2
    #when "TRACK" then track
    #when "PACKAGES" then packages
    when "EXIT" then exit
    end
  end

  def test1
    @address_2 = "8820 Washington Blvd"
    @city = "Culver"
    @state = "CA"
    @zip_5 = "90232"
    verify_display_results
  end

  def test2
    @address_2 = "29851 AVENTUR"
    @city = "RANCHO SANTA"
    @state = "CA"
    @zip_5 = "92688"
    verify_display_results
  end

  def verify
    @current_menu = "verify"
    option = ""
    banner("ADDRESS STANDARDIZATION TOOL")
    puts "Corrects errors in street addresses including abbreviations and missing information and supplies ZIP Codes and ZIP Codes + 4."
    spacer
    puts "Optional commands:"
    spacer
    puts "    back: Returns to the previous menu."
    puts "    exit: Terminates the program."
    spacer

    puts "Enter Apartment/Suite number:"
    @address_1 = gets.strip.upcase
    spacer

    @address_2 = ""
    until !@address_2.empty?
      puts "Enter the Street address (required):"
      @address_2 = gets.strip.upcase
      spacer
    end

    puts "Enter the City:"
    @city = gets.strip.upcase
    spacer

    puts "Enter the State:"
    @state = gets.strip.upcase
    spacer

    puts "Enter the ZIP code:"
    @zip_5 = gets.strip.upcase
    spacer

    until option == "Y" || option == "N"
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
    when "Y" then verify_display_results
    when "N" then verify
    end
  end

  def verify_display_results
    option = ""
    address = {
      address_1: @address_1,
      address_2: @address_2,
      city: @city,
      state: @state,
      zip_5: @zip_5
    }
    banner("STANDARDIZED ADDRESS")
    until option == "Y" || option == "N"
      response = ShippingTool::AddressValidation.new(address)
      response.display_address
      spacer

      puts "Do you want to save this address? (y/n)"
      spacer
      #binding.pry
      option = gets.strip.upcase
    end
    spacer

    i = 3
    case option
    when "Y"
      puts "Please enter a name to save this address under:"
      customer = gets.strip.split(/(\W)/).map(&:capitalize).join
      #titleize customer name
      response.save_address(customer)
      spacer

      banner("Address saved under #{customer}.")

      until i == 0
        puts "Returning to main menu in #{i}."
        sleep 1
        i -= 1
      end

      puts ShippingTool::AddressValidation.all

      start
    when "N"
      banner("Address not saved.")

      until i == 0
        puts "Returning to main menu in #{i}."
        sleep 1
        i -= 1
      end

      start
    end
  end

  def back
    case @current_menu
    when "verify" then start
    end
  end
end
