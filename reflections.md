## Reflections

1. How long did you spend working on this project?
It took me about an three and a half hours all together.

2. What was the most rewarding challenge you conquered?
I think the most rewarding part is having a good understanding of Object Oriented Ruby.  I like that the language feels like it is extremely flexible and easy to extend, yet it enforces strict OOP principles.  OOP is clearly meant to make programming more natural and less error prone and I find that to be the case with Ruby and the other languages I know.

3. What two additional features did you build? Why?
The two extra features that I added are as follows:

#### Feature 1
The app will now print receipts when there is a new transaction.  I did this because it makes sense that this app would print receipts.  I was trying to make this a more realistic application that someone would use.  On top of that, I added a UnknownTransactionError, which will throw when trying to print a receipt for a transaction not in the system.

#### Feature 2
I also added the ability to track product transactions in the bank account.  This may not really be realistic without persistence, but I thought that it was it would be a useful feature for later iterations.

To test it, you can see that there is a default bank account defined in app.rb.  You can call any of the methods on it like `withdraw`, `deposit`, etc.  I would likely tie the bank to the transactions and automatically update it, but I was not entirely sure if I should alter the app.rb file too much, so I did not do much with it for this submission.