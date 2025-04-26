# Day 1 - First Steps in Swift

We should install Xcode >=15.0 from the Mac AppStore, and we will use a **Swift Playground** for all the code here. **Swift Playground** are sandboxes where we can try out Swift code easily, seeing the result of our work side by side with the code.

## Variables and Constants

When we first create a blank `.playground` file, it contains the default template like:

<img src="/Users/binliu/Documents/100DaysOfSwiftUI/Day1/imgs/create_var.png" alt="default_hello" style="zoom:50%;" />

Swift gives us two ways of storing data.

```swift
var greeting = "Hellp, playgorund!"
```

This creates a new variable called `greeting`. The `import Cocoa` line brings a huge collection of code provided by Apple to make app building easier.

Swift does allow semicolons, but they are rarely used. We only want to use it if we want to write two pieces of code on the same line.

After we initailize a variable, we can change its value:

```swift
var name = "Derrick Rose"
name = "Kyrie Irving"
name = "Steph Curry"
```

The `var` keyword is used to **create variables** whose values can be modified after intialization. If we do **NOT** ever want to change a value, we need to use a **constant** instead.

We will use the `let` keyword to create constants:
```swift
let character = "Babyface"
```

When we use `let` to initialize a *constant*, its value cannot be changed. If we try the following,

```swift
let character = "Babeface"
character = "Artist on Court"
```

<img src="/Users/binliu/Documents/100DaysOfSwiftUI/Day1/imgs/change_const_error.png" alt="change_const_error" style="zoom:50%;" />

To print out the value of any variable, we can use `print()` function. Users cannot see what is printed, but it is helpful to check values.

```swift
var playerName = "Steph Curry"
print(playerName)
```

The naming convention across Swift developers is **camelCase**:

```swift
let managerName = "Bin Liu"
let catBreed = "Devon Rex"
```

A rule of thumb in Swift is to prefer constant over variables. It does not only give Swift the change to optimize our code a little better, but it also allows Swift to make sure we never change a constant's value by accident.

### Constants VS Variables

Variables are a great way to store temporary data. If we create a variable and then never change its value, it is recommended to use constants.

## Creating Strings

Swift's strings start and end with double quotes. We can put any text, emojis, or other characters:

```swift
let actor = "Steph Curry"
let filename = "GSW.jpg"
let result = "⭐️ You win! ⭐️"
```

To use other double quotes inside a string, we need to add a backslash:

```swift
let quote = "Then he tapped a sign saying \"Believe\" and walked away."
```

To create a multi-line string constant:

```swift
let movie = """
A day in
the lieft of an
Apple engineer
"""
```

Once we have a string, there are additional methods we can use.

The `.count` is used to read the length of the string:

```swift
print(actor.count)
```

The `.uppercased()` is used to return string in uppercase:

```swift
print(result.uppercased())
```

The `hasPrefix()` is used to check if a string starts with some letters of our choosing:

```swift
print(movie.hasPrefix("A day"))
```

Similarly, the `hasSuffix()` checks if a string ends with some text:

```swift
print(filename.hasSuffix(".jpg"))
```

### Multi-line Strings

```swift
var burns = """
The best laid schemes
O’ mice and men
Gang aft agley
"""
```

Swift sees those line breaks in our string as being part of the text itself, so that string actually contains three lines.

## Storing Integer Numbers

```swift
let score = 10
```

Integers can be really big

```swift
let reallyBig = 100000000
```

but this is hard to quickly identify the amount. We can use underscores to break up numbers however we want:
```swift
let reallyBigGood = 100_000_000
```

It does matter how many underscores we used:

```swift
let reallyBigWeird = 1_00__00___00____00
```

We can create integers from other integers:

```swift
let lowerScore = score - 2
let higherScore = score + 10
let doubledScore = score * 2
let squaredScore = score * score
let halvedScore = score / 2
print(score)
```

To avoid making new constants each time, we can use variables to assign the result back to the original number.

```swift
var counter = 10
counter = counter + 5
```

This can be written as

```swift
counter += 5
print(counter)
```

Similar *compound assignment operators* can be used:

```swift
counter *= 2
print(counter)
counter -= 10
print(counter)
counter /= 2
print(counter)
```

Integers also have their own functionalities.

The `isMultiple(of:)` is used to find out whether it is a multiple of another integer:
```swift
let number = 120
print(number.isMultiple(of: 3))
```

we can just use the number directly:

```swift
print(120.isMultiple(of: 3))
```

## Storing Decimal Numbers

```swift
let decimal = 0.1 + 0.2
print(decimal)
```

When we create a floating-piont number, Swift considers it to be a **Double**, which means that Swift allocates twice the amount of storage as some older languages would do.

Swift considers decimals to be a wholly different type of data to integers. We cannot do things like adding an integer to a decimal:

```swift
let a = 1
let b = 2.0
let c = a + b
```

By doing so, we will have an error

<img src="/Users/binliu/Documents/100DaysOfSwiftUI/Day1/imgs/add_int_to_decimal.png" alt="add_int_to_decimal" style="zoom:50%;" />

This is called *type safety*: Swift will NOT let us mix different types of data by accident.

If we want that to happen, we need to tell Swift explicitly:

```swift
let c = a + Int(b)
```

or

```swift
let d = Double(a) + b
```

to make sure the data types are correct.

Swift decides whether we want to create a `Double` or an `Int` based on the number we provide:

```swift
let double1 = 3.1
let double2 = 3131.3131
let double3 = 3.0
let int1 = 3
```

Combined with type safety, this means that once Swift has decided what data type a constant or variable holds, it must always hold that same data type.

```swift
var name = "Nicolas Cage"
name = "John Travolta"
print(name)
name = 57
```

This throws an error:

<img src="/Users/binliu/Documents/100DaysOfSwiftUI/Day1/imgs/change_data_type.png" alt="change_data_type" style="zoom:50%;" />

We can also apply compound assignment operators to decimal numbers:

```swift
var rating = 5.0
rating *= 2
```

