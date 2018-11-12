class ShippingTool::CLI
  include ShippingTool::User, ShippingTool::UI, ShippingTool::Test

  def validate_username
    user_check = ShippingTool::AddressValidation.new(valid_address).valid_user?

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
    menu_options = ["VERIFY", "ADDRESSES", "EXIT", "TEST", "TEST1", "TEST2", "TEST3"]
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
    when "TEST" then test_0
    when "TEST1" then test_1
    when "TEST2" then test_2
    when "TEST3" then test_3
    end
  end

  def verify
    @current_menu = "verify"
    banner("ADDRESS STANDARDIZATION TOOL")
    puts "Corrects errors in street addresses including abbreviations and missing information and supplies ZIP Codes and ZIP Codes + 4."
    spacer
    puts "To begin, please fill out the following:"
    spacer

    puts "Apartment/Suite number: "
    @address_1 = gets.strip.upcase
    spacer

    @address_2 = ""
    until !@address_2.empty?
      puts "Street address (required): "
      @address_2 = gets.strip.upcase
      spacer
    end

    puts "Enter the City: "
    @city = gets.strip.upcase
    spacer

    puts "Enter the State: "
    @state = gets.strip.upcase
    spacer

    puts "Enter the ZIP code: "
    @zip_5 = gets.strip.upcase
    spacer

    menu_options = ["Y", "", "N"]
    option = "!"
    until option_check(option, menu_options)
      puts "Is this correct? (y/n)"
      spacer
      puts "    Apt/Suite: #{@address_1}"
      puts "    Address  : #{@address_2}"
      puts "    City     : #{@city}"
      puts "    State    : #{@state}"
      puts "    ZIP Code : #{@zip_5}"
      spacer
      option = gets.strip.upcase
    end

    case option
    when "Y", ""
      verify_error_check
    when "N"
      reset
      verify
    end
  end

  def verify_error_check
    address = {
      address_1: @address_1,
      address_2: @address_2,
      city: @city,
      state: @state,
      zip_5: @zip_5
    }

    validated_address = ShippingTool::AddressValidation.new(address)

    if validated_address.any_error?
      menu_options = ["Y", "", "N"]
      option = "!"
      until option_check(option, menu_options)
        banner("ADDRESS STANDARDIZATION TOOL")
        validated_address.display
        spacer
        puts "Do you want to try again? (y/n)"
        spacer
        option = gets.strip.upcase
      end
      spacer

      case option
      when "Y", ""
        verify
      when "N"
        reset
        start
      end
    else
      verify_save?(validated_address)
    end
  end

  def verify_save?(validated_address)
    menu_options = ["Y", "", "N"]
    option = "!"
    until option_check(option, menu_options)
      banner("ADDRESS STANDARDIZATION TOOL")
      validated_address.display
      spacer
      puts "Do you want to save this address? (y/n)"
      spacer
      option = gets.strip.upcase
    end

    banner("ADDRESS STANDARDIZATION TOOL")

    i = 3
    case option
    when "Y", ""
      customer = ""
      until !customer.empty?
        puts "Please enter customer name to save this address under:"
        spacer
        #customer = gets.strip.split(/(\W)/).map(&:capitalize).join#titleize
        customer = gets.strip.upcase
      end
      spacer

      validated_address.save(customer)
      spacer

      puts "    Address saved under: #{customer}"

      until i == 0
        puts "Returning to main menu in #{i}."
        sleep 1
        i -= 1
      end
    when "N"
      puts "    Address not saved."

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

  def reset
    @customer = nil
    #@firm_name = nil
    @address_1 = nil
    @address_2 = nil
    @city = nil
    @state = nil
    @urbanization = nil
    @zip_5 = nil
    @zip_4 = nil
  end
end
