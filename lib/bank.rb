# The bank account class takes care of depositing keeping track of our funds
  # I was not sure exactly how to demonstrate this in app.rb, but these all work.
  # It would be more useful to make this app interactive with user input and such.
class BankAccount
  @@funds_available = 100000000.00 # You get a ton of money when signing up for a business account

  def initialize(funds)
    @@funds_available = funds
  end

  # Takes an options hash.  The option should be deposit or withdrawal.
    # Set the amount of the transaction.
  def self.make_transaction(options)
    type = options[:type]
    amount = options[:amount]
    if type == "deposit"
      deposit_funds(amount)
    elsif type == "withdrawal"
      withdraw_funds(amount)
    end
  end

  protected

  # Return true if the transaction is possible based on the amount of money available.
  def transaction_possible?(amount)
    return amount < @funds_available # Return whether the amount is greater than the funds available.
  end

  def deposit_funds(amount)
    @@funds_available += amount
  end

  def withdraw_funds(amount)
    if transaction_possible?(amount)
      @@funds_available -= amount
    else
      puts "Sorry, but you need more money to do that"
    end
  end

end