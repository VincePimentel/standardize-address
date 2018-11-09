class ShippingTool::CLI
  def login
    option = ""
    until option == "INFO" || option == "EXIT" || option == "VINCE" || option == "TEST" || option.length >= 1
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
    when "VINCE" then start
    when "TEST" then test
    else invalid
    end
  end

  def test
    test = ShippingTool::AddressValidateRequest.new({user: "253VINCE6398"})
    binding.pry
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

  def start
    @current_menu = "start"
    option = ""
    until option == "SEARCH" || option == "ADDRESSES" || option == "TRACK" || option == "PACKAGES" || option == "EXIT"
      banner("WELCOME")
      puts "What would you like to do today?"
      spacer
      puts "    search   : Search and standardize an address."
      puts "    addresses: Displays all previous address searches."
      puts "    track    : Track package status."
      puts "    packages : Displays all previous package tracks."
      puts "    exit     : Terminates the program."
      spacer
      option = gets.strip.upcase
    end

    case option
    when "SEARCH" then search
    when "ADDRESSES" then addresses
    when "TRACK" then track
    when "PACKAGES" then packages
    when "EXIT" then exit
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
    zip_code = gets.strip.upcase
    spacer

    until option == "Y" || option == "N" || option == ""
      puts "Is this correct? (y/n)"
      spacer
      puts "    Address : #{address_2}"
      puts "    City    : #{city}"
      puts "    State   : #{state}"
      puts "    ZIP Code: #{zip_code}"
      spacer
      option = gets.input.upcase
    end

    case option
    when "Y" then standardize
    when "" then standardize
    when "N" then search
    end
  end

  def standardize
    #ShippingTool::Scraper.new.standardize
    option = ""
    banner("STANDARDIZED ADDRESS")
    until option == "Y" || option == "N"
      puts "    Address : 29851 AVENTURA STE K"
      puts "    City    : RANCHO SANTA MARGARITA"
      puts "    State   : CA"
      puts "    ZIP Code: 92688-2014"
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

  def banner(message)
    top_border_spacer(message.length)
    puts message
    bottom_border_spacer(message.length)
  end

  def spacer
    puts ""
  end

  def border(length = 1)
    puts "=" * length
  end

  def top_border_spacer(length = 1)
    spacer
    border(length)
  end

  def bottom_border_spacer(length = 1)
    border(length)
    spacer
  end

  def full_border_spacer(length = 1)
    spacer
    border(length)
    spacer
  end
end
