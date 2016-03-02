class BankAccount
  include Singleton # We should probably only have one bank account
  attr_reader :funds_available

  def initalize(funds, password)
    @funds_available = funds
    @password = password
  end

  def make_transacion(options = {}, password)
    type = options[:type]
    amount = options[:amount]
    if password = @password
      if type == "deposit"
        deposit_funds(amount)
      elsif type == "withdrawal"
        withdraw_funds(amount)
      end
    else
      puts "Password is incorrect.  Please don't hack the bank."
    end
  end

  private

  def transaction_possible?(amount)
    return amount > @funds_available # Return whether the amount is greater than the funds available.
  end

  def deposit_funds(amount)
    @funds_available += amount
  end

  def withdraw_funds(amount)
    if transaction_possible?(amount)
      @funds_available -= amount
    else
      puts "Sorry, but you need more money to do that"
    end
  end

end