# This file contains instructions for how to create a database.
# If the file does not exist yet, it opens a new writable file
# and adds a header for the columns: id, brand, product, price

module Schema

  def db_create
    if !File.exist?(file_path)
      CSV.open(file_path, "wb") do |csv|
        csv << ["id", "brand", "product", "price"]
      end
    end
  end
  def file_path
    File.dirname(__FILE__) + "/data.csv"
  end
end
