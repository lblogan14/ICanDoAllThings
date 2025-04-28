# Day 2 - Simple Data Types

## Storing Booleans

```swift
let filename = 'basketball.jpg'
print(filename.hasSuffix('.jpg'))
let num = 120
print(num.isMultiple(of: 4))
```

Create boolean values:

```swift
let goodDogs = true
let gameOver = false
```

We can also assign a boolean value from other code:

```swift
let isMultiple = 120.isMultiple(of: 3)
```

Booleans do not have arithmetic operators, but booleans have a special operator, `!`, which means "not".

```swift
var isAuthenticated = false
isAuthenticated = !isAuthenticated
print(isAuthenticated)
isAuthenticated = !isAuthenticated
print(isAuthenticated)
```

If we can `toggle()` function on a boolean, it will flip a true value to false, and a false value to true.

```swift
var gameOver = false
print(gameOver)
gameOver.toggle()
print(gameOver)
```

This is the same is using `!`.

## Joining Strings Together

There are two ways to combine strings in Swift.

Using `+` 

```swift
let firstPart = "Hello, "
let secondPart = "world!"
let greeting = firstPart + secondPart
```

We can also do this with multiple strings:

```swift
let people = "Haters"
let action = "hate"
let lyric = people + " gonna " + action
print(lyric)
```

This technique works fine for small things, but we do not want to do it too much because each time Swift sees two strings being joined together using `+` , is has to make a new strings out of them before continuing.

```swift
let luggageCode = "1" + "2" + "3" + "4" + "5"
```

Swift cannot join all those strings in one go. Instead, it will join the first two to make `"12"`, then join `"12"` and `"3"` to make `"123"`, then join `"123"` and `"4"` to make `"1234"`, and so on. It makes temporary strings to hold `"12"`, `"123"`, `"1234"` even though they are not ultimately used when the code finishes.

Swift has a better solution called **string interpolation**, and it lets us efficiently create strings from other strings, but also from integers, decimal numbers, and more.

We can write a *backslash* inside our string, then place the name of a variable or constant inside parentheses.
```swift
let name = "Steph"
let age = 30
let message = "Hello, my name is \(name) and I'm \(age) years old."
print(message)
```

Joining strings with `+` does not let us add integers to string:

```swift
let number = 11
let missionMessage = "Apollo " + number + " landed on the moon."
```

We can ask Swift to treate the number like a string:

```swift
let missionMessage = "Apollo " + String(number) + " landed on the moon."
```

but it is still faster and easier to read with string interpolation:
```swift
let missionMessage = "Apollo \(number) landed on the moon."
```

We can also put calculations inside string interpolation:
```swift
print("5 x 5 is \(5 * 5)")
```



## Simple Data

Summary:

- Create constants using `let`, and variables using `var`.
- If we do not intend to chagne a value, make sure we use `let` keyword.
- Swift uses *double quotes* for strings. Strings have functionality such as `count` and `uppercased()`.
- Multi-line strings are created with triple double quotes `"""..."""`
- Swift's `Int` data has functioanlity, such as `isMultiple(of: )`
- Swift's decimal numbers are called `Double`.
- Swift use `true` and `false` for boolean. The `!` operator or the `toggle()` function is used to flip the boolean values.
- String interpolation lets us place constants and vairables into our string in a streamlined, efficient way by placing a backslash and a parentheses, for example, `"/(var)"`