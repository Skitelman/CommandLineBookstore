require "./config/environment"

##
# The `Application` class has one publicly accessible method `call`.
# This runs the applicaion until the user enters an exit code.
#
class Application
  EXIT_RESPONSES = ["9", "quit", "exit", "q",]

  def call
    welcome
    help
    response = ""
    cart = Order.new([])
    until EXIT_RESPONSES.include?(response)
      puts "Please enter the number of a command: "
      response = gets.chomp.strip
      case response
      when "0", "help"
        help
      when "1"
        ProductApplication.display_all
      when "2"
        DiscountApplication.display_all
      when "3"
        CartApplication.add_product_to_cart(cart)
      when "4"
        CartApplication.add_discount_to_cart(cart)
      when "5"
        ProductApplication.add_product
      when "6"
        DiscountApplication.add_discount
      when "7"
        CartApplication.clear_cart(cart)
      when "8"
        CartApplication.display_cart(cart)
      end
    end
    puts "Goodbye"
  end

  private

  def help
    puts %(
      You can do one of the following:
      0: Help (displays this message)
      1: View All Products
      2: View All Discounts
      3: Add Product To Cart
      4: Add Discount To Cart
      5: Create New Product
      6: Create New Discount
      7: Clear Cart
      8: Display Cart
      9: Quit
    )
  end

  def welcome
    puts "Welcome to the Command Line Bookstore!\n"
  end
end
