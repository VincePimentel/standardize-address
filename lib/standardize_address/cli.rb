class StandardizeAddress::CLI
  include StandardizeAddress::Username, StandardizeAddress::Tests

  def initialize
    @request = StandardizeAddress::Address.new
    @response = StandardizeAddress::Scraper.new(@request)
    # @address.set_attributes
    # validate_username
  end

  def validate_username
    if username.empty?
      spacer
      puts "    Please make sure that you have inserted your USPS Web Tools API username inside /lib/standardize_address.rb.".red
      spacer
      puts "    To request a username, please visit:"
      puts "    https://www.usps.com/business/web-tools-apis/web-tools-registration.htm".yellow
      spacer
    elsif !username.empty? && !@address.valid?
      spacer
      puts "    Username is incorrect or does not exist. Please double check your username inside /lib/standardize_address.rb.".red
      spacer
    else
      menu
    end
  end

  def menu
    @current_menu = "menu"
    menu_options = %w[
      VERIFY
      V
      LIST
      L
      EXIT
      E
      T1
      T2
      T3
    ]
    menu_options << ""
    user_option = "!"
    until valid_option?(user_option, menu_options)
      banner("ADDRESS STANDARDIZATION MENU")
      puts "What would you like to do today?".light_white
      spacer
      command("verify: Standardize an address.")
      command("list  : Displays a list of previously standardized addresses.")
      #puts "    track    : Track package status."
      #puts "    packages : Displays all previously tracked packages."
      command("exit  : Ends the program.")
      spacer
      user_option = gets.strip.upcase
    end

    case user_option
    when "VERIFY", "V", "" then verify
    when "LIST", "L" then list
    #when "TRACK" then track
    #when "PACKAGES" then packages
    when "EXIT", "E" then exit

    #TEST CASES
    when "T1" then test_1
    when "T2" then test_2
    when "T3" then test_3
    end
  end

  def verify
    @current_menu = "verify"
    banner("ADDRESS STANDARDIZATION")
    puts "Corrects errors in street addresses including abbreviations and missing information and supplies ZIP Codes and ZIP Codes + 4.".green
    spacer
    puts "To begin, please fill out the following:".green
    spacer

    address_2 = ""
    until !address_2.empty?
      puts "Street address (required): ".light_white
      address_2 = gets.strip.upcase
      spacer
    end

    puts "Apartment/Suite number: ".light_white
    address_1 = gets.strip.upcase
    spacer

    puts "Enter the City: ".light_white
    city = gets.strip.upcase
    spacer

    puts "Enter the State: ".light_white
    state = gets.strip.upcase
    spacer

    puts "Enter the ZIP code: ".light_white
    zip_5 = gets.strip.upcase
    spacer

    menu_options = ["Y", "", "N"]
    user_option = "!"
    until valid_option?(user_option, menu_options)
      puts "Is this correct? (".light_white + "y/n".red + ")".light_white
      spacer
      puts "    Apt/Suite: #{address_1.green}"
      puts "    Address  : #{address_2.green}"
      puts "    City     : #{city.green}"
      puts "    State    : #{state.green}"
      puts "    ZIP Code : #{zip_5.green}"
      spacer
      user_option = gets.strip.upcase
    end

    case user_option
    when "Y", ""
      @address.address_1 = address_1
      @address.address_2 = address_2
      @address.city = city
      @address.state = state
      @address.zip_5 = zip_5
      verify_error_check
    when "N"
      verify
    end
  end

  def verify_error_check
    @address.set_attributes

    if @address.any_error?
      menu_options = ["Y", "", "N"]
      user_option = "!"
      until valid_option?(user_option, menu_options)
        banner("ADDRESS STANDARDIZATION")
        puts error_message
        spacer
        puts "Do you want to try again? (".light_white + "y/n".red + ")".light_white
        user_option = gets.strip.upcase
      end
      spacer

      case user_option
      when "Y", "" then verify
      when "N" then menu
      end
    else
      save_address?
    end
  end

  def error_message
    message = ["Error:", "The", "that you have entered was not found."]

    case @address.number
    when "-2147219401"
      issue = "Street Address"
    when "-2147219400"
      issue = "City"
    when "-2147219402"
      issue = "State"
    end

    "    #{message[0].red} #{message[1].green} #{issue.yellow} #{message[2].green}"
  end

  def save_address?
    menu_options = ["Y", "", "N"]
    user_option = "!"
    until valid_option?(user_option, menu_options)
      banner("STANDARDIZED ADDRESS")
      display_address
      spacer
      puts "Do you want to save this address? (".light_white + "y/n".red + ")".light_white
      user_option = gets.strip.upcase
    end
    spacer

    case user_option
    when "Y", ""
      @name = ""
      until !@name.empty?
        puts "Please enter a name to save this address under:".light_white
        #name = gets.strip.split(/(\W)/).map(&:capitalize).join#titleize
        @name = gets.strip.upcase
      end
      spacer

      name_address = {"Name": @name}.merge(address_hash)
      #Places :"Name" in front of the hash

      StandardizeAddress::Address.new(name_address)

      #ASK TO OVERWRITE IF IT EXISTS
      puts "    Address saved under: #{@name.green}"
      spacer
      countdown_to_menu
    when "N"
      puts "    Address not saved.".red
      spacer
      countdown_to_menu
    end

    menu
  end

  def address_hash
    {
      "Apt/Suite": @address.address_1,
      "Street": @address.address_2,
      "City": @address.city,
      "State": @address.state,
      "ZIP Code": @address.zip_5,
      "ZIP + 4": @address.zip_4,
      "Note": @address.return_text.split(": ")[1]
    }
  end

  def display_address(index = 0)
    if @current_menu == "detail"
      address = StandardizeAddress::Address.all[index - 1]
    else
      address = address_hash
    end

    new_address = address.reject{ |key, value| value.to_s.empty? }

    new_address.each do |key, value|
      spacing = " " * (longest_key(address_hash).first.length - key.length)

      if key == "Apt/Suite"
        puts "    #{key}: #{value.green}"
      else
        puts "    #{key}#{spacing}: #{value.green}"
      end
    end
  end

  def longest_key(address_hash)
    address_hash.max_by { |key, value| key.length }
  end

  def list
    @current_menu = "list"
    banner("STANDARDIZED ADDRESSES")

    if StandardizeAddress::Address.all.empty?
      puts "    No addresses currently saved.".red
      spacer
      countdown_to_menu
      menu
    else
      StandardizeAddress::Address.view_list
      spacer

      total = StandardizeAddress::Address.all.size

      menu_options = (1..total).to_a.map(&:to_s)
      menu_options.push("BACK", "", "EXIT")
      user_option = "!"
      until valid_option?(user_option, menu_options)
        puts "Which address would you like to view more about? (".light_white + "[total: #{total}]/back/exit".red + ")".light_white
        user_option = gets.strip.upcase
      end
      spacer

      case user_option
      when "BACK", "" then back
      when "EXIT" then exit
      else detail(user_option.to_i)
      end
    end
  end

  def detail(index)
    @current_menu = "detail"
    banner("STANDARDIZED ADDRESS")

    display_address(index)
    spacer

    menu_options = ["BACK", "B", "", "MENU", "M", "EXIT"]
    user_option = "!"
    until valid_option?(user_option, menu_options)
      puts "Where do you want to go? (".light_white + "back/menu/exit".red + ")".light_white
      user_option = gets.strip.upcase
    end

    case user_option
    when "BACK", "B", "" then list
    when "MENU", "M" then menu
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

  def valid_option?(user_option, menu_options)
    !([user_option] & menu_options).empty?
    #Returns true/false depending on the values returned by intersecting the user input and menu option. If true, user input is valid else false.
  end

  def exit
    menu_options = ["Y", "N"]
    user_option = "!"
    until valid_option?(user_option, menu_options)
      spacer
      puts "You will lose all addresses saved during this session!".colorize(:red)
      spacer
      puts "Are you sure you want to exit? (".light_white + "y/n".red + ")".light_white
      user_option = gets.strip.upcase
    end
    spacer

    case user_option
    when "Y"
      puts "Goodbye! Have a nice day!".light_white
      spacer
    when "N"
      menu
    end
  end

  def countdown_to_menu
    i = 3
    until i == 0
      puts "Returning to main menu in " + "#{i}".green
      sleep 1
      i -= 1
      print "\e[A\e[2K"
      #Moves cursor one line up and clears
    end
  end

  def command(string)
    puts "    #{string[0].colorize(:light_white)}#{string[1..-1].split(": ")[0]}: #{string.split(": ")[1].green}"
  end

  def banner(message)
    spacer
    border(message.length)
    puts message.light_white
    border(message.length)
    spacer
  end

  def spacer
    puts ""
  end

  def border(length = 1)
    puts "=".light_white * length
  end

  def full_border_spacer(length = 1)
    spacer
    border(length)
    spacer
  end
end
