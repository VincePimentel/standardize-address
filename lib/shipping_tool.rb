module ShippingTool
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
