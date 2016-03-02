## Reflections

1. How long did you spend working on this project?
It took me about an hour and a half all together.

2. What was the most rewarding challenge you conquered?
I am just so happy that I am using Ruby OOP now.  I think the best thing I accomplished is having a good understanding of how Ruby goes about OOP.  I like that the language feels like it is extremely flexible and easy to extend, yet it enforces strict OOP principles.  I think everyone can benefit from learning about the choices that Matz made when developing Ruby.

I started reading a really interesting book about how Ruby was built: [see here]](http://rhg.rubyforge.org/).  It's a dense read, but it I find it to be really interesting.

3. What two additional features did you build? Why?
The two extra features that I added are as follows:

#### Feature 1
The app will now print receipts when there is a new transaction.  I did this because it makes sense that this app would print receipts.  I was trying to make this a more realistic application that someone would use.  On top of that, I added a UnknownTransactionError, which will throw when trying to print a receipt for a transaction not in the system.

#### Feature 2
I also added a subclass of Logger, which will create a log of errors.  Realistically, I would not make the app throw when their are errors.  I would probably use the `rescue` feature and would log the errors so the execution would not stop.  I am hoping this will be a useful feature going forward.  I realize that this functionalitty is built into the Logger class, but I wanted to customize it, so I subclassed it and made all of the defined inherit from it.