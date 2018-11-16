class StandardizeAddress::CLI
  include StandardizeAddress::User, StandardizeAddress::UI

  def login
    option = ""
    until option == "INFO" || option == "EXIT" || option == "VINCE" || option == "TEST" || option.length >= 4 || !!option.match(/\b[\d]+[A-Z]+[\d]+\b/)
      banner("SHIPPING TOOL LOGIN")
      puts "To use the tracker, you must be a registered user."
      puts "Please enter your user ID:"
      spacer
      puts "Optional commands:"
      spacer
      puts "    info: Get information on how to request a user ID."
      puts "    exit: Terminates the program."
      spacer
      option = gets.strip.upcase
    end

    case option
    when "INFO" then info
    when "EXIT" then exit
    when "VINCE" then start#REMOVE ME
    when "TEST" then test#REMOVE ME
    else
      if !!option.match(/\b[\d]+[A-Z]+[\d]+\b/) && user_check(option)
        @user = option
        start
      else
        puts "User ID entered is incorrect or does not exist. Please try again:"
        login
      end
    end
  end

  def test
    #user = "253VINCE6398"
    address0 = {}
    address1 = {
      customer: "Vincent G.",
      address_2: "8820 Washington Blvd",
      city: "Culver",
      state: "CA",
      zip_5: "90232"
    }
    address2 = {
      customer: "Alice C.",
      address_2: "6955 Mission",
      city: "Daly City",
      state: "CA",
      zip_5: "94014"
    }
    test1 = StandardizeAddress::Verify.new(address1)
    #test2 = StandardizeAddress::Verify.new(address2)
    #test1.add_to_address_list
    #test2.add_to_address_list
    #test1.validate_address
    #test1.display_address
    #test1.current_address_index
    #test1.valid_user?
    test1.display_address
  end


  def user_check
    address = {
      address_2: "29851 AVENTURA STE K",
      city: "RANCHO SANTA MARGARITA",
      state: "CA",
      zip_5: "92688",
      zip_4: "9997"
    }
    StandardizeAddress::Verify.new(address).valid_user?
  end

  def invalid
    option = ""
    until option == "INFO" || option == "EXIT" || option == "VINCE" || option.length >= 1
      banner("INVALID USER ID")
      puts "User ID entered is incorrect or does not exist. Please try again:"
      spacer
      puts "Optional commands:"
      spacer
      puts "    info: Get information on how to request a user ID."
      puts "    exit: Terminates the program."
      spacer
      option = gets.strip.upcase
    end

    case option
    when "INFO" then info
    when "EXIT" then exit
    when "VINCE" then start
    else invalid
    end
  end



  def search
    @current_menu = "search"
    option = ""
    banner("ADDRESS LOOKUP AND STANDARDIZATION TOOL")
    puts "Corrects errors in street addresses, including abbreviations and missing information, and supplies ZIP Codes and ZIP Codes + 4."
    spacer
    puts "Optional commands:"
    spacer
    puts "    back: Returns to the previous menu."
    puts "    exit: Terminates the program."
    spacer

    puts "Enter Apartment/Suite number:"
    address_1 = gets.strip.upcase
    spacer
    puts "Enter the Street address:"
    address_2 = gets.strip.upcase
    spacer
    puts "Enter the City:"
    city = gets.strip.upcase
    spacer
    puts "Enter the State:"
    state = gets.strip.upcase
    spacer
    puts "Enter the ZIP code:"
    zip_5 = gets.strip.upcase
    spacer

    until option == "Y" || option == "N" || option == ""
      puts "Is this correct? (y/n)"
      spacer
      puts "    Apt/Suite: #{address_1}"
      puts "    Address  : #{address_2}"
      puts "    City     : #{city}"
      puts "    State    : #{state}"
      puts "    ZIP Code : #{zip_5}"
      spacer
      option = gets.strip.upcase
    end

    @address = {
      address_1: address_1,
      address_2: address_2,
      city: city,
      state: state,
      zip_5: zip_5
    }

    case option
    when "Y" then standardize
    when "" then standardize
    when "N" then search
    end
  end

  def standardize
    option = ""
    banner("STANDARDIZED ADDRESS")
    until option == "Y" || option == "N"
      StandardizeAddress::VerifyValidation.new(@user, @address).display_address

      # puts "    Address : 29851 AVENTURA STE K"
      # puts "    City    : RANCHO SANTA MARGARITA"
      # puts "    State   : CA"
      # puts "    ZIP Code: 92688-2014"
      spacer

      puts "Do you want to save this address? (y/n)"
      spacer
      option = gets.strip.upcase
    end
    spacer

    case option
    when "Y"
      puts "Please enter a name to attach this address to:"
      spacer
      option = gets.strip.upcase

      puts "Address saved."
      spacer
      timer = 5
      until timer == 0
        puts "Returning to main menu in #{timer}."
        timer -= 1
        sleep 1
      end
    when "N"
      puts "Address not saved."
      spacer
      timer = 5
      until timer == 0
        puts "Returning to main menu in #{timer}."
        timer -= 1
        sleep 1
      end
    end

    start
  end

  def addresses
    @current_menu = "addresses"
    option = ""
    banner("ADDRESS BOOK")
    puts "1) USPS: 29851 AVENTURA STE K, RANCHO SANTA MARGARITA, CA 92688"
    puts "2) FLATIRON SCHOOL: 11 BROADWAY, NEW YORK, NY 10004"
    spacer
    option = gets.strip
    spacer
    case option
    when "1"
      puts "    Name    : USPS"
      puts "    Address : 29851 AVENTURA STE K"
      puts "    City    : RANCHO SANTA MARGARITA"
      puts "    State   : CA"
      puts "    ZIP Code: 92688-2014"
    when "2"
      puts "    Name    : FLATIRON SCHOOL"
      puts "    Address : 11 BROADWAY #260"
      puts "    City    : NEW YORK"
      puts "    State   : NY"
      puts "    ZIP Code: 10004"
    end

    option = ""
    until option == "BACK" || option == "EXIT"
      spacer
      puts "What would you like to do?"
      spacer
      puts "    back: Returns to the previous menu."
      puts "    exit: Terminates the program."
      spacer
      option = gets.strip.upcase
    end

    case option
    when "BACK" then back
    when "EXIT" then exit
    end
  end

  def back
    case @current_menu
    when "search" then start
    when "addresses" then addresses
    end
  end

  def exit
    spacer
    puts "Goodbye! Have a nice day!"
    spacer
  end
end
