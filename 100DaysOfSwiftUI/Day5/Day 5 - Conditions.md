# Day 5 - Conditions

## Checking a condition is true or false

Swift handles these with `if` statements, which let us check a condition and run some code if the condition is true:

```swift
if someCondition {
  print("Do something")
}
```

`someCondition` is where we write our condition; if the condition is true, then we print `"Do something"` message.

The curly brackets `{ }` enclose the code block to run if our condition happens to be true. We can include as much code as we want:

```swift
if someCondition {
  print("Do something")
  print("Do something else")
  print("Do a third thing")
}
```

For example,

```swift
let score = 85

if score > 80 {
	print("Great job!")
}
```

```swift
let speed = 88
let percentage = 85
let age = 18

if speed >= 88 {
  print("Where we're going we don't need roads.")
}

if percentage < 85 {
  print("Sorry, you failed the test.")
}

if age >= 21 {
  print("You're eligible to drink.")
}
```

These examples are all numerical comparisons. We could also compare strings:

```swift
let ourName = "Dave Lister"
let friendName = "Arnold Rimmer"

if ourName < friendName {
  print("It's \(ourName) vs \(friendName)")
}

if ourName > friendName {
  print("It's \(friendName) vs \(ourName)")
}
```

If the string inside `ourName` comes before the string inside `friendName` when sorted alphabetically, it prints `ourName` first then `friendName`.

```swift
// Make an array of 3 numbers
var numbers = [1, 2, 3]

// Add a 4th
numbers.append(4)

// If we have more than 3 items
if numbers.count > 3 {
  // Remove the oldest number
  numbers.remove(at: 0)
}

print(numbers)
```

This will print `[2, 3, 4]`.

```swift
let country = "Canada"

if country == "Australia" {
  print("G'day!")
}

let name = "Steph Curry"

if name != "Anonymous" {
  print("Welcom, \(name)")
}
```

The `==` operator means "is equal to" and the `!=` operator means "is not equal to".

We can use this to check empty strings:

```swift
var username = "sc30"

// If `username` contains an empty string
if username == "" {
  // Assign "Anonymous" to it
  username = "Anonymous"
}

print("Welcome, \(username)!")
```

We can also use other ways to do this check:

```swift
if username.count == 0 {
  username = "Anonymous"
}
```

In many languages this is very fast, but not in Swift since the `count` method makes Swift go through and count up all the letters one by one. A much better approach to do this check is to use `isEmpty`, and this method is available to strings, arrays, dictionaries, and sets.

```swift
if username.isEmpty == true {
  username = "Anonymous"
}
```

We can omit `== true` part since `username.isEmpty` is already a boolean,

```swift
if username.isEmpty {
  username = "Anonymous"
}
```

## Checking multiple conditions

```swift
let age = 16

if age >= 21 {
  print("You can drink beer")
} else {
  print("Sorry, you're too yound")
}
```

Now our condition looks like:

```swift
if someCondition {
    print("This will run if the condition is true")
} else {
    print("This will run if the condition is false")
}
```

We can also have `else if`:

```swift
let a = false
let b = true

if a {
  print("Code to run if `a` is true")
} else if b {
  print("Code to run if `a` is false but `b` is true")
} else {
  print("Code to run if both `a` and `b` are false")
}
```

We can keep adding more and more `else if` condiions if we want.

We can also check more than one conditions with nested conditions:

```swift
let temp = 25

if temp > 20 {
  if temp < 30 {
    print("It's a nice day.")
  }
}
```

Swift provides a shorter alternative for this example, where we can use `&&` to combine two conditions together and the whole condition will only be true if the two parts inside the condition are true:

```swift
if temp > 20 && temp < 30 {
  print("It's a nice day.")
}
```

`&&` is the "and" *logical operator* and `||` is the "or" operator, where a condition is true if either sub-condition is true.

```swift
let userAge = 14
let hasParentalConsent = true

if userAge >= 18 || hasParentalConsent == true {
  print("You can buy the game.")
}
// OR more convenient
if userAge >= 18 || hasParentalConsent {
  print("You can buy the game.")
}
```

In the example below, we will create an enum called `TransportOption` which contains five cases:

```swift
enum TransportOption {
  case airplane, helicopter, bicycle, car, scooter
}

let transport = TransportOption.airplane

if transport == .airplane || transport == .helicopter {
  print("Let's fly!")
} else if transport == .bicycle {
  print("I hope there's a bike path...")
} else if transport == .car {
  print("Time to get stuck in traffic.")
} else {
  print("I'm going to ride a scooter now.")
}
```

We can see that when we set the value for `transport` we need to be explicit. Once that has happened, we do not need to write `TransportOption` anymore because Swift knows `transport` must be some kind of `TransportOption`.

## Using switch statements to check multiple conditions

Sometimes `if` and `else if` are hard to read. For example,

```swift
enum Weather {
  case sun, rain, wind, snow, unknown
}

let forecast = Weather.sun

if forecast == .sun {
  print("It should be a nice day.")
} else if forecast == .rain {
  print("Pack an umbrella.")
} else if forecast == .wind {
  print("Wear something warm.")
} else if forecast == .snow {
  print("School is cancelled.")
} else {
  print("Our forecast generator is broken!")
}
```

We keep writing `forecast` and the whole structure is cumbersome. This is why we can use `switch`, which lets us check individual cases one by one:

```swift
switch forecast {
  case .sun:
  	print("It should be a nice day.")
 	case .rain:
  	print("Pack an umbrella.")
  case .wind:
  	print("Wear something warm.")
  case .snow:
  	print("School is cancelled.")
  case .unknown:
  	print("Our forecast generator is broken!")
}
```

We start with `switch forecast`, which tells Swift that is the value we want to check. Each of the `case` statement is compared against `forecast`, and we do not need to write explicitly.

In Swift, all `switch` statements *must* be exhausive, meaning that all possible values must be handled in there so we cannot leave one off by accident.

Therefore, if we switch on a string then it is not possible to make an exhausive check of all possible strings because there is an infinite number, so instead we need to provide a *default case* - code to run if none of the other cases match.

```swift
let place = "Metropolis"

switch place {
  case "Gotham":
  	print("You're Batman!")
  case "Mega-City One":
  	print("You're Judge Dredd!")
  case "Wakanda":
  	print("You're Black Panther!")
  default:
  	print("Who are you?")
}
```

NOTE: **Swift checks its cases in order and runs the first one that matches** If we place `default` before any other case, that case is useless because it will never be matched and Swift will refuse to build our code.

If we explicitly want Swift to carry on executing subsequent cases, use `fallthrough`, which is not commonly used.

```swift
let day = 5
print("My true love gave to me…")

switch day {
case 5:
    print("5 golden rings")
case 4:
    print("4 calling birds")
case 3:
    print("3 French hens")
case 2:
    print("2 turtle doves")
default:
    print("A partridge in a pear tree")
}
```

In the above example, we will only see the following in the output:

```
My true love gave to me…
5 golden rings
```

However, if we add `fallthrough`:

```swift
let day = 5
print("My true love gave to me…")

switch day {
	case 5:
    print("5 golden rings")
    fallthrough
	case 4:
    print("4 calling birds")
    fallthrough
	case 3:
    print("3 French hens")
    fallthrough
	case 2:
    print("2 turtle doves")
    fallthrough
	default:
    print("A partridge in a pear tree")
}
```

This will print out

```
My true love gave to me…
5 golden rings
4 calling birds
3 French hens
2 turtle doves
A partridge in a pear tree
```

It will match the first case and print `5 golden rings` and then the `fallthrough` line means `case 4` will execute and print `4 calling birds`, and so on.



## Using the ternary conditional operator for quick tests

Ternary operators let us check a condition and return one of two values: something if the condition is true, and something if it is false. For example, we can create a constant called `age` that stores someone's age, then create a second constant called `canDrink` that will store whether that person is able to drink or not:

```swift
let age = 18
let canDrink = age >= 21 ? "Yes" : "No"
```

The ternary operator is split into three parts:

- a check (`age >= 21`)
- something for when the condition is true (`"Yes"`)
- something for when the condition is false (`"No"`)

That makes it exactly like a regular `if` and `else` block, in the same order.

We can use the term WTF to remember the order of ternary operator. It stands for "what, true, false".

Another example:

```swift
let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")
```

```swift
let names = ["Jayne", "Kaylee", "Mal"]
let crewCount = names.isEmpty ? "No one" : "\(names.count) people"
print(crewCount)
```

It gets a little difficult to read when our condition use `==` to check for equality:

```swift
enum Theme {
  case light, dark
}
let theme = Theme.dark

let background = theme == .dark ? "black" : "white"
print(background)
```

The ternary operators are useful because

```swift
print(hour < 12 ? "It's before noon" : "It's after noon")
```

Here we only need online, but if we rewrite it using `if` and `else`:

```swift
if hour < 12 {
    print("It's before noon")
} else {
    print("It's after noon")
}
```

