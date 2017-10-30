require "./config/environment"

class CartApplication
  ##
  # Displays formatted line times in a cart and totals them all with discounts
  #
  def self.display_cart(order)
    return_string = "Your cart:\n\n"
    total = total_cost(order) || 0
    order.line_items.each do |line_item|
      line_item_processor = LineItemProcessor.new(line_item, order.discount)
      return_string << if order.discount.nil?
        LineItemFormatter.cart_line_without_order_discount(line_item_processor)
      else
        LineItemFormatter.cart_line_with_order_discount(line_item_processor, total.to_s.size)
      end
    end
    return_string << "---\nTotal #{PriceFormatter.price_in_dollars(total)}"
    puts return_string
    return_string
  end

  ##
  # Gets user input to add an item to the cart.
  # Asks user for input until a valid product id and quantity are entered.
  #
  def self.add_product_to_cart(cart)
    product = nil
    while product.nil?
      puts "Please enter the product id you would like to add:".colorize(:green)
      product_id = gets.chomp.strip.to_i
      product = Product.find(product_id)
    end
    quantity = 0
    while quantity <= 0
      puts "Please enter the quantity of the product you would like:".colorize(:green)
      quantity = gets.chomp.strip.to_i
    end
    cart.add_line_item(LineItem.new(product_id: product_id, quantity: quantity))
  end

  ##
  # Gets user input to add a discount to the cart.
  # Asks user for input until a valid discount code is entered.
  #
  def self.add_discount_to_cart(cart)
    discount = nil
    while discount.nil?
      puts "Please enter the discount code you would like to use:".colorize(:green)
      discount_code = gets.chomp.strip.upcase.to_sym
      discount = Discount.find_by_code(discount_code)
    end
    cart.discount_code = discount_code
  end

  ##
  # Removes all line items and discounts from the cart.
  #
  def self.clear_cart(cart)
    cart.clear_line_items
    cart.discount_code = nil
    puts "Cart is empty"
  end

  ##
  #
  # Returns total cost of an order
  #
  def self.total_cost(order)
    order.line_items.map do |line_item|
      LineItemProcessor.new(line_item, order.discount).discounted_total
    end.inject(:+)
  end
end
