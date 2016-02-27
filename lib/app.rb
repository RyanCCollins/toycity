require 'json'

# Easily calculate the percent difference by extending class numeric
class Numeric
  def percent_diff(n)
    ((1 -self.to_f / n.to_f) * 100.0).round(2)
  end
end

# Return the date in standard mm/dd/yyyy format
def date_now
  return Time.now.strftime("%m/%d/%Y")
end

# Construct headers for the various sections
def product_header
  header = "\n" +
  "                     _            _       \n" +
  "                    | |          | |      \n"  +
  " _ __  _ __ ___   __| |_   _  ___| |_ ___ \n" +
  "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|\n" +
  "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\\n" +
  "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/\n" +
  "| |                                       \n" +
  "|_|                                       \n" +
  "\n"
  return header # I know you don't have to call return, but I think it's easier to read.
end

# Print "Sales Report" in ascii art
  # (Note): Will return then print in the print_data method
def report_header
  header = "\n" +
    "" + "\n" + date_now + "\n" +
    " _______  _______  _        _______  _______  \n" + 
    "(  ____ \(  ___  )( \      (  ____ \(  ____ \ \n" +
    "| (    \/| (   ) || (      | (    \/| (    \/ \n" +
    "| (_____ | (___) || |      | (__    | (_____  \n" +
    "(_____  )|  ___  || |      |  __)   (_____  ) \n" +
    "      ) || (   ) || |      | (            ) | \n" +
    "/\____) || )   ( || (____/\| (____/\/\____) | \n" +
    "\_______)|/     \|(_______/(_______/\_______) \n" +
    "\n" +                                             
    " _______  _______  _______  _______  _______ _________ \n" +
    "(  ____ )(  ____ \(  ____ )(  ___  )(  ____ )\__   __/ \n" +
    "| (    )|| (    \/| (    )|| (   ) || (    )|   ) (    \n" +
    "| (____)|| (__    | (____)|| |   | || (____)|   | |    \n" +
    "|     __)|  __)   |  _____)| |   | ||     __)   | |    \n" +
    "| (\ (   | (      | (      | |   | || (\ (      | |    \n" +
    "| ) \ \__| (____/\| )      | (___) || ) \ \__   | |    \n" +
    "|/   \__/(_______/|/       (_______)|/   \__/   )_(    \n"
    
    # I know that you don't need to call return, but I think it makes the intention more clear
    return header 
end

# Returns "Brands" in ascii art
def brand_header
  # Return the Brands header
  header = "\n" +
  " _                         _     \n" +
  "| |                       | |    \n" +
  "| |__  _ __ __ _ _ __   __| |___ \n" +
  "| '_ \\| '__/ _` | '_ \\ / _` / __|\n" +
  "| |_) | | | (_| | | | | (_| \\__ \\\n" +
  "|_.__/|_|  \\__,_|_| |_|\\__,_|___/\n"
  return header
end

#Takes a report array returns output of the products
# For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price
def make_products_section(report)
  products = report[:products]
  output = ""
  # Loop through the product array and print the items
  products.each do |product|
    output += "\n" # Print a new line before just to make sure there is no overlap
    output += "#{product[:title]}\n"
    output += "************************************\n"
    output += "Full Retail Price    |    $#{product[:full_price]}\n"
    output += "Total Purchases      |    #{product[:total_purchases]}\n"
    output += "Total Sales          |    $#{product[:total_sales]}\n"
    output +=  "Average Price        |    $#{product[:average_price]}\n"
    output += "Percentage Discount  |    #{product[:discount]}%"
    output += "\n" # New Line
  end
  return output # Again, no need to call return, but makes the intention clear
end

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined
def make_brand_section(report)
    #For each brand in the hash, loop and print the results
  brands = report[:brands]
  output = ""
  brands.each do |brand|
    puts brand
    output += "\n"
    output += "#{brand[:name]}\n"
    output += "************************************\n"
    output += "Count          |   #{brand[:count]}\n" # It is ambiguous whether you are looking for the number of types of toys for the brand, 
    output += "Total Stock    |   #{brand[:stock]}\n" # or the stock of toys for that brand
    output += "Average Price  |   $#{brand[:average_price].round(2)}\n" # Call round(2) here to make sure that it prints with only 2 characters.
    output += "Total Revenue  |   $#{brand[:total_revenue].round(2)}\n\r"
    output += "\n"
  end
  return output
end

# Parse the product data and return it in usable hash
def parse_product(item)
  # Construct the product hash and return it
    # Initialize a few rogue local variables to help make things more clear.
  product = {}
  purchases = item["purchases"]
  product[:title] = item["title"]
  # Although we are not actually printing the purchases, I am still storing them in the hash
    # in case we want to do something else with them.
  product[:purchases] = purchases
  product[:total_purchases] = item["purchases"].length
  product[:full_price] = item["full-price"].to_f
  
  # Initialize these variables as 0 so that they are not nil
  product[:average_price] = 0.0
  product[:discount] = 0.0
  total_sales = 0
  
  # For each purchase, add to the total sales value.
  purchases.each do |purchase|
    total_sales += purchase["price"]
  end
    
  product[:total_sales] = total_sales
    
  # If total_purchases is not 0, calculate the average price and average_discount
    # NOTE: I did use ternary operators here, but it got messy and that is not the ruby way.
  unless product[:total_purchases] == 0
    product[:average_price] = total_sales / product[:total_purchases]
    product[:discount] = product[:average_price].percent_diff(product[:full_price])
  end
  return product
end

# Take the original items and parse them into a usable 
  # Hash that will get returned and pushed onto the report Hash.
def parse_brand(item)
  brand = {}
  # Loop through the purchases and add them up to calculate total_revenue
  total_revenue = 0.0
  
  item["purchases"].each { |a| total_revenue += a["price"] }
  
  # Build and return a brand hash
  brand[:name] = item["brand"]
  
  brand[:total_sales] = item["purchases"].length
  brand[:total_revenue] = total_revenue
  brand[:count] = 1
  brand[:stock] = item["stock"]
  # Check for no purchases.
  unless item["purchases"] == nil
    brand[:average_price] = total_revenue / item["purchases"].length
  end
  
  return brand
end

# I chose to seperate out the update_brand method
  # because it is desctructive in that it overwrites data
def update_brand!(report, item)
  total_revenue = 0
  item["purchases"].each { |a| total_revenue += a["price"] }
  report[:brands].each do |brand|
    if brand[:name] == item["brand"]
      brand[:count] += 1
      brand[:total_sales] += item["purchases"].length
      brand[:total_revenue] += total_revenue.round(2)
      brand[:average_price] = brand[:total_revenue] / brand[:total_sales]
      brand[:stock] += item["stock"]
    end
  end
  return report
end

#Check if a brand exists in a given report and return true if it does.
  # This provides an easy way to update report data for a given brand.
  # Pass in the brand_name and the report object.
def brand_exists?(brand_name, report)
  report[:brands].each do |brand|
    return brand[:name] == brand_name
  end
  return false
end

def generate_report_data(items)
  report = {:products => [], :brands => []}
  items.each do |item|
    report[:products].push(parse_product(item))
    # Unless the brand exists, parse it.
    unless brand_exists?(item["brand"], report)
      # Then push it into the brands array.  I know you can use << but I think push is more widely recognizable.
      report[:brands].push(parse_brand(item))
    else
      # Update the brand if it exists and return the report.
      report = update_brand!(report, item)
    end
  end
  return report
end

# Return headings as long as the option to print headings is on
def make_headings(section)
  if should_make_headings?
    if section == 'report'
      return report_header
    end
    if section == 'products'
      return product_header
    end
    if section == 'brands'
      return brand_header
    end
  end
  return "" # Return an empty string if no conditions are hit
end

# If the headings option is set, then return true.
  # I likely would not do this, but I needed more methods that returned boolean
def should_make_headings?
  return $options[:print_headings]
end

# Compile output from the report object.  Returns one long string based on options set.
def compile_output(report)
  output = ""
  output += make_headings('report')
  if $options[:print_products] == true
    output += make_headings('products')
    output += make_products_section(report)
  end
  if $options[:print_brands] == true
    output += make_headings('brands')
    output += make_brand_section(report)
  end
  return output
end

# Output the report to the file specified in target
  # Defined with ! because it is overwriting a file
def output_report!(output)
  if $options[:print_to_file]
    $report_file.write(output)
  end
  if $options[:print_to_terminal]
    puts output
  end
end

# Set the global report options to either the default, or to whatever is passed in.
  # Generate the report data
  # and then output the report
def create_report!(items, options = {:print_products => true, :print_brands => true, :print_headings => true, 
                                                            :print_to_terminal => true, :print_to_file => true })
  #Set the global options value.  Since the options change each time 
    # and are set to defaults, using a global is fine
  $options = options 
  report = generate_report_data(items)
  output_report!(compile_output(report))
end

# Get path to products.json, read the file into a string,
  # and transform the string into a usable hash
def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  products_hash = JSON.parse(file) # Not defined globally, because it doesn't need to be.
  $report_file = File.new("report.txt", "w+") # Defined report file in global scope for output of report.
    
  # Label the items hash for easy reference from start method
    # I tend to avoid globals, so you will see me passing the items around.
  $items = products_hash["items"]
  # Store the "options" hash globally
  $options = {}
end

# Start the program running
def start
  setup_files
  # You can set report options, such as whether to print products
    # brands and report headings.  Also you can set whether to print to
    # file, terminal or both.  If nothing is set, it will default to true for everything.
    # NOTE: I left the options hash here, so you can play with each option and try it.
    # but normally, I'd leave it blank and just let the default values kickin.
  options = {:print_products => true, :print_brands => true, :print_headings => true, 
                                    :print_to_terminal => true, :print_to_file => true }
  create_report!($items, options)
end

start