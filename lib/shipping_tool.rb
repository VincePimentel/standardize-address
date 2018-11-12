module ShippingTool
  module User
    def username
      #ENTER YOUR USPS WEB TOOLS API USERNAME BELOW AS A STRING (" ")
      "253VINCE6398"
    end
  end

  module Navigation
    def option_check(option, menu_options)
      !([option] & menu_options).empty?
      #Tests to see if user input is a menu option.
    end

    def exit
      spacer
      puts "Goodbye! Have a nice day!"
      spacer
    end
  end

  module UI
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
end

require_relative "../config/environment"
