# Day 7 - Functions, Part 1

Functions let us wrap up pieces of code so they can be used in lots of places.

## Reuse Code with Functions

```swift
func showWelcome() {
    print("Welcome to my app!")
    print("By default This prints out a conversion")
    print("chart from centimeters to inches, but you")
    print("can also set a custom range if you want.")
}
```

A function starts with the `func` keyword. The `()` after the function name `showWelcome` is necessary and indicates `showWelcome` is a function. Inside `()` we can pass in data to customize the way the function works. For example, we used to have:

```swift
let number = 139

if number.isMultiple(of: 2) {
  print("Even")
} else {
  print("Odd")
}
```

`isMultiple(of: )` is a function that belongs to `Int`. Similarly we have the `random(in:)`:

```swift
let roll = Int.random(in: 1...20)
```

We can make our own functions:

```swift
func printTimesTables(number: Int) {
  for i in 1...12 {
    print("\(i) x \(number) is \(i * number)")
  }
}

// call our function
printTimesTables(number: 5)
```

The `number: Int` inside the parentheses is a *parameter*, and whoever calls this function *must* pass in an integer.

When `printTimesTables()` is called, we need to explicitly write `number: 5` (i.e., we need to write the parameter name as part of the function call.), and The naming of parameters becomes more important when we have multiple parameters:

```swift
func printTimesTables(number: Int, end: Int) {
  for i in 1...end {
    print("\(i) x \(number) is \(i * number)")
  }
}

// call our updated function
printTimesTables(number: 5, end: 20)
```

In Swift, we must always pass the parameters in the order they were listed when we created the function,

```swift
// not valid to call
printTimesTables(end:20, number: 5)
```

## Return Values from Functions

```swift
func rollDice() -> Int {
  return Int.random(in: 1...6)
}

let result = rollDice()
print(result)
```

The `return` keyword sends back our data from the defined function. Notice that `func rollDice() -> Int`. When we say our function will return an `Int`, Swift will make sure it always return an `Int`. We cannot forget to send back a value because our code will not build.

Another example: If we call `sorted()` on any string, we get a new string back with all the letters in alphabetical order. So if we do that for both strings, we can use `==` to compare them to see if their letters are the same.

```swift
func areLettersIdentical(string1: String, string2: String) -> Bool {
  let first = string1.sorted()
  let second = string2.sorted()
  return first == second
}
```

The new constants `first` and `second` are not really needed in this case, and we can skip those temporary constants:

```swift
func areLettersIdentical(string1: String, string2: String) -> Bool {
  return string1.sorted() == string2.sorted()
}
```

We can even do it better! We have told Swift that this function must return a Boolean, and because there is only one line of code in the function, Swift knows that is the one that must return data. Because of this, when a function has only one line of code, we can remove the `return` keyword entirely:

```swift
func areLettersIdentical(string1: String, string2: String) -> Bool {
  string1.sorted() == string2.sorted()
}
```

NOTE: this only works when our function contains a single line of code, and in particular that line of code must actually return the data we promised to return.



Third example: Pythagorean theorem

```swift
func pythagoras(a: Double, b: Double) -> Double {
  let input = a * a + b * b
  let root = sqrt(input)
  return root
}

let c = pythagoras(a: 3, b: 4)
print(c)
```

We can boil down this function into a single line:

```swift
func pythagoras(a: Double, b: Double) -> Double {
  sqrt(a * a + b * b)
}
```

One last thing: If our function does not return a value, we can still use `return` by itself to force the function to exit early. For example, if we have a check that the input matches what we expected, and if it does not, we want to exit the function immediately before continuing.

## Return multiple values from functions

If we want to return multiple values from a function, we could use an array:

```swift
func getUser() -> [String] {
  ["Steph", "Curry"]
}

let user = getUser()
print("Name: \(user[0]) \(user[1])")
```

This is problematic... what if using a dictionary:

```swift
func getUser() -> [String: String] {
  [
    "firstName": "Steph",
    "lastName": "Curry"
  ]
}

let user = getUser()
print("Name: \(user["firstName", default: "Anonymous"]) \(user["lastName", default: "Anonymous"])")
```

The default values are pretty redundant...

Swift has a solution in the form of *tuples*. Like arrays, dictionaries, and sets, **tuples** let us put multiple pieces of data into a single variable, but unlike those other options, tuples have a fixed size and can have a variety of data types:

```swift
func getUser() -> (firstName: String, lastName: String) {
  (firstName: "Steph", lastName: "Curry")
}

let user = getUser()
print("Name: \(user.firstName) \(user.lastName)")
```

- Our return type now is `(firstName: String, lastName: String)`, which is a tuple containing two strings. 
- Each string in our tuple has a name. They are not in quotes: they are specific names for each item in our tuple, as opposed to the kinds of arbitrary keys we had in dictionaries.
- Inside the function we can use the names directly.

In addition, if we return a tuple from a function, Swift already knows the names we give each item in the tuple, so we do not need to repeat them when using `return`:

```swift
func getUser() -> (firstName: String, lastName: String) {
  ("Steph", "Curry")
}
```

Sometimes we do not need to specify names but use numerical indices starting from 0:

```swift
func getUser() -> (String, String) {
  ("Steph", "Curry")
}

let user = getUser()
print("Name: \(user.0) \(user.1)")
```

If a function returns a tuple we can actually pull the tuple apart into individual values if we want to:

```swift
func getUser() -> (firstName: String, lastName: String) {
    (firstName: "Steph", lastName: "Curry")
}

let user = getUser()
let firstName = user.firstName
let lastName = user.lastName
```

Instead, we can do

```swift
let (firstName, lastName) = getUser()
print("Name: \(firstName) \(lastName)")
```

If we do not need all the values from the tuple, we can go a step further by using `_` to tell Swift to ignore that part of the tuple:

```swift
let (firstName, _) = getUser()
print("Name: \(firstName)")
```

## Customize parameter labels

```swift
func rollDice(sides: Int, count: Int) -> [Int] {
  // start with an empty array
  var rolls = [Int]()
  
  // roll as many dices as needed
  for _ in 1...count {
    // add each result to our array
    let roll = Int.random(in: 1...sides)
    rolls.append(roll)
  }
  
  // send back all the rools
  return rolls
}

let rolls = rollDice(sides: 6, count: 4)
```

Think about the `hasPrefix()` function. When we call `hasPrefix()`, we pass in the prefix to check for directly, instead of saing `hasPrefix(string: )` or `hasPrefix(prefix: )`.

When we define the parameters for a function, we can actually add *two* names: one for use where the function is called, and one for use inside the function itself. `hasPrefix()` uses this to specify `_` as the external name for its parameter, which tells Swift to *ignore this* and causes there to be no external label for that parameter. For example,

```swift
func isUppercase(string: String) -> Bool {
  string == string.uppercased()
}
let string = "HELLO, WORLD"
let result = isUppercase(string: string)
```

The `string: string` seems annoying. We can add an underscore before the parameter name so that we can remove the external parameter label:

```swift
func isUppercase(_ stirng: String) -> Bool {
  string == string.uppercased()
}

let string = "HELLO, WORLD"
let result = isUppercase(string)
```

This is used a lot in Swift, such as with `append()` or `contains()` functions.



The second problem with external parameter names is when they are not quite right. For example,

```swift
func printTimesTables(number: Int) {
  for i in 1...12 {
    print("\(i) x \(number) is \(i * number)")
  }
}

printTimesTable(number: 5)
```

The code is valid, but the call site does not read well: `printTimesTables(number: 5`)

```swift
func printTimesTables(for: Int) {
  for i in 1...12 {
    print("\(i) x \(for) is \(i * for)")
  }
}

printTimesTables(for: 5)
```

This reads much better at the call site - we can say "print times table for 5", but we have invalid `for` keyword used here.

We already saw how we can put `_` before the parameter name so that we do not need to write an external parameter name. The other option is to write a second name there: one to use externally, and one to use internally:

```swift
func printTimesTables(for number: Int) {
  for i in 1...12 {
    print("\(i) x \(number) is \(i * number)")
  }
}

printTimesTables(for: 5)
```

In the `for number: Int`, the external name is `for`, the internal name is `number`, and it is of type `Int`.

Hence, Swift gives us two important ways to control parameter names: we can use `_` for the external parameter name so that it does not get used, or add a second name there so that we have both external and internal parameter naems.