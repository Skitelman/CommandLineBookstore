require "./config/environment"

class ProductApplication

  ##
  # Displays all products in the `Product` data_store
  #
  def self.display_all
    return_string = "The Bookstore has the following titles:\n"
    Product.all.each do |product|
      return_string << format_product(product)
    end
    puts return_string
  end

  ##
  # Interface for adding a new product to the bookstore
  #
  def self.add_product
    product = nil
    while product.nil?
      begin
        puts "Please enter the product name for the new product:".colorize(:green)
        name = gets.chomp.strip
        puts "Please enter the price (in dollars) for the new product:".colorize(:green)
        price_cents = (gets.chomp.strip.to_f * 100).to_i
        product = Product.new(name: name, price_cents: price_cents)
      rescue => error
        puts error.message.colorize(:red)
      end
    end
    puts format_product(product)
  end

  private

  def self.format_product(product)
    "#{product.id}: \"#{product.name}\" (#{PriceFormatter.price_in_dollars(product.price_cents)})\n"
  end
end
