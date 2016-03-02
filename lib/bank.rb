# Note:  I implemented this because I would like it to be a feature I use for later iterations.
  # Not all functionality is being utilized.
class BankAccount

  def initialize()
    @id = Random.new.rand(1000..9999) # Get a random number.  If defining multiple accounts, we need to check the ids.
    @total_balance = 200.0 # Just like monopoly, you get 200 bucks to start!
  end

  # Takes an options hash.  The option should be deposit or withdrawal.
    # Set the amount of the transaction.
  def deposit(amount)
    @total_balance += amount
  end

  def withdraw(amount)
    if withdrawal_possible?(amount)
      @balance -= amount
    else
      puts "Sorry, but you need more money to do that"
    end
  end

  def calculate_new_balance
    @total_balance
  end

  # Return true if the transaction is possible based on the amount of money available.
  def withdrawal_possible?(amount)
    return amount < @total_balance
  end
end