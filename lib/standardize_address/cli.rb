class StandardizeAddress::CLI
  include StandardizeAddress::Username, StandardizeAddress::Test

  def initialize
    @user = StandardizeAddress::Verify.new
  end

  def validate_username
    if @user.valid_user?
      menu
    else
      if username.empty?
        puts "Please make sure that you have saved your USPS Web Tools API Username inside /lib/standardize_address.rb."
        spacer
        puts "To request a username, please visit:"
        puts "https://www.usps.com/business/web-tools-apis/web-tools-registration.htm"
      elsif !username.empty? && !@user.valid_user?
        puts "Username is incorrect or does not exist. Please double check your username inside /lib/standardize_address.rb."
      end
    end
  end

  def menu
    @current_menu = "menu"
    menu_options = ["VERIFY", "LIST", "EXIT", "TEST", "TEST1", "TEST2", "TEST3"]
    option = "!"
    until option_check(option, menu_options)
      banner("ADDRESS STANDARDIZATION MENU")
      puts "What would you like to do today?"
      spacer
      puts "    verify: Standardize an address."
      puts "    list  : Displays a list of previously standardized addresses."
      #puts "    track    : Track package status."
      #puts "    packages : Displays all previous package tracks."
      puts "    exit  : Terminates the program."
      spacer
      option = gets.strip.upcase
    end
    spacer

    case option
    when "VERIFY" then verify
    when "LIST" then list
    #when "TRACK" then track
    #when "PACKAGES" then packages
    when "EXIT" then exit

    #TEST CASES
    when "TEST" then test_0
    when "TEST1" then test_1
    when "TEST2" then test_2
    when "TEST3" then test_3
    end
  end

  def verify
    @current_menu = "verify"
    banner("ADDRESS STANDARDIZATION")
    puts "Corrects errors in street addresses including abbreviations and missing information and supplies ZIP Codes and ZIP Codes + 4."
    spacer
    puts "To begin, please fill out the following:"
    spacer

    address_2 = ""
    until !address_2.empty?
      puts "Street address (required): "
      address_2 = gets.strip.upcase
      spacer
    end

    puts "Apartment/Suite number: "
    address_1 = gets.strip.upcase
    spacer

    puts "Enter the City: "
    city = gets.strip.upcase
    spacer

    puts "Enter the State: "
    state = gets.strip.upcase
    spacer

    puts "Enter the ZIP code: "
    zip_5 = gets.strip.upcase
    spacer

    menu_options = ["Y", "", "N"]
    option = "!"
    until option_check(option, menu_options)
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

    case option
    when "Y", ""
      address_hash = {
        address_1: address_1,
        address_2: address_2,
        city: city,
        state: state,
        zip_5: zip_5
      }
      verify_error_check(address_hash)
    when "N"
      verify
    end
  end

  def verify_error_check(address_hash)
    address = StandardizeAddress::Verify.new(address_hash)

    if address.any_error?
      menu_options = ["Y", "", "N"]
      option = "!"
      until option_check(option, menu_options)
        banner("ADDRESS STANDARDIZATION")
        address.display
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
        menu
      end
    else
      verify_save?(address)
    end
  end

  def verify_save?(address)
    menu_options = ["Y", "", "N"]
    option = "!"
    until option_check(option, menu_options)
      banner("ADDRESS STANDARDIZATION")
      puts "Address found! Standardized address:"
      spacer
      address.display
      spacer
      puts "Do you want to save this address? (y/n)"
      spacer
      option = gets.strip.upcase
    end
    spacer

    case option
    when "Y", ""
      name = ""
      until !name.empty?
        puts "Please enter a name to save this address under:"
        spacer
        #name = gets.strip.split(/(\W)/).map(&:capitalize).join#titleize
        name = gets.strip.upcase
      end
      spacer

      @user = address
      @user.save(name)
      #ASK TO OVERWRITE IF IT EXISTS
      puts "    Address saved under: #{name}"
      spacer
      countdown_to_menu
    when "N"
      puts "    Address not saved."
      spacer
      countdown_to_menu
    end

    menu
  end

  def list
    @current_menu = "list"
    banner("STANDARDIZED ADDRESSES")

    if StandardizeAddress::Verify.all.empty?
      puts "    No addresses currently saved."
      spacer
      countdown_to_menu
      menu
    else
      @user.list_view
      spacer

      menu_options = (1..StandardizeAddress::Verify.all.size).to_a.map(&:to_s)
      menu_options.push("BACK", "EXIT")
      option = "!"
      until option_check(option, menu_options)
        puts "Enter number to view detailed information:"
        spacer
        option = gets.strip
      end
      spacer

      case option
      when "BACK" then back
      when "EXIT" then exit
      else detail(option)
      end
    end
  end

  def detail(option)
    @current_menu = "detail"
    banner("STANDARDIZED ADDRESS")

    @user.detailed_view(option)
    spacer

    menu_options = ["BACK", "", "MENU", "EXIT"]
    option = "!"
    until option_check(option, menu_options)
      puts "Where do you want to go? (back/menu/exit)"
      spacer
      option = gets.strip.upcase
    end

    case option
    when "BACK", "" then list
    when "MENU" then menu
    when "EXIT" then exit
    end
  end

  def back
    case @current_menu
    when "verify","list"
      menu
    when "detail"
      list
    end
  end

  def option_check(option, menu_options)
    !([option] & menu_options).empty?
    #Returns true/false depending on the values returned by intersecting the user input and menu option. If true, user input is valid else false.
  end

  def exit
    menu_options = ["Y", "N"]
    option = "!"
    until option_check(option, menu_options)
      puts "You will lose all standardized addresses during this session!"
      puts "Are you sure you want to exit? (y/n)"
      spacer
      option = gets.strip.upcase
    end
    spacer

    case option
    when "Y"
      puts "Goodbye! Have a nice day!"
    when "N"
      menu
    end
  end

  def countdown_to_menu
    i = 3
    until i == 0
      puts "Returning to main menu in #{i}."
      sleep 1
      i -= 1
    end
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
