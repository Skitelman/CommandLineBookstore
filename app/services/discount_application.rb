require "./config/environment"

class DiscountApplication

  ##
  # Displays all discounts in the `Discount` data store
  #
  def self.display_all
    return_string = "The Bookstore has the following discounts:\n"
    Discount.all.each do |discount|
      return_string << format_discount(discount)
    end
    puts return_string
  end

  ##
  # Interface for adding a new discount to the bookstore
  #
  def self.add_discount
    discount = nil
    while discount.nil?
      begin
        puts "Please enter the code for the new discount:".colorize(:green)
        code = gets.chomp.strip.upcase.to_sym
        puts "Please enter the percentage for the new discount:".colorize(:green)
        percentage = gets.chomp.strip.to_i
        puts "Please enter the type of discount(\"all\" or \"product_list\"):".colorize(:green)
        type = gets.chomp.strip.to_sym
        if type == :product_list
          message = "Please enter a comma separated list of the product ids you want this discount to apply to:"
          puts message.colorize(:green)
          product_ids = gets.chomp.strip.split(",").map(&:to_i)
        end
        discount = Discount.new(code: code, percentage: percentage, type: type, product_ids: product_ids)
      rescue => error
        puts error.message.colorize(:red)
      end
    end
    puts format_discount(discount)
  end

  private

  def self.format_discount(discount)
    return_string = "#{discount.id}: \"#{discount.code}\" will take #{discount.percentage}% off "
    if discount.product_list?
      return_string << "product(s): #{discount.product_ids}\n"
    else
      return_string << "all products\n"
    end
    return return_string
  end
end
