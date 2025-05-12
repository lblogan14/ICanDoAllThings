# Day 15 - Swift Review

## Creating constants and variables

Values in variables can be changed later

```swift
var name = "Ted"
name = "Rebecca"
```

If we don't want to change a value, use a *constant* instead:

```swift
let user = "Daphne"

print(user)
```

## Strings

Strings in Swift start and end with double quotes:
```swift
let actor = "Tom Cruise"

// work with emoji
let actor2 = "Tom Cruise 🏃‍"

// use double quotes in string
let quote = "He tapped a sign saying \"Believe\" and walked away."

// multiple lines
let movie = """
A day in
the life of an
Apple engineer
"""
```

To count how many letters in a string:

```swift
print(actor.count)
```

Other methods:

```swift
print(quote.hasPrefix("He"))
print(quote.hasSuffix("Away."))
```

## Integers

Swift stores integers using the type `Int`.

```swift
let score = 10
let higherScore = score + 10
let halvedScore = score / 2
```

It supports compound assignment operators
```swift
var counter = 10
counter += 5
```

Other methods:

```swift
let number = 120
print(number.isMultiple(of: 3))

let id = Int.random(in: 1...1000)
```

## Decimals

Swift stores floating numbers as `Double`

```swift
let score = 3.0
```

## Booleans

Swift uses the type `Bool` to store true or false:

```swift
let goodDogs = true
let gameOver = false
```

We can flip a Boolean by calling `toggle()`:

```swift
var isSaved = false
isSaved.toggle()
```

## Joining strings

String interpolation with backslash:

```swift
let nem = "Steph"
let age = 37
let message = "I'm \(name) and I'm \(age) years old."
print(message)
```

## Arrays

```swift
var colors = ["Red", "Green", "Blue"]
let numbers = [4, 8, 15, 16]
var readings = [0.1, 0.5, 0.8]

print(colors[0])
print(readings[2])
```

If our array is variable, we can use `append()` to add new items:

```swift
colors.append("Cyan")
```

The type of data we add must match whatever was already there.

Methods:

```swift
print(colors.count)

colors.remove(at: 0)
print(colors.count)

print(colors.contains("Octarine"))
```

## Dictionaries

```swift
let employee = [
  "name": "Steph",
  "job": "Athlete"
]
```

To read data from dictionaries, we need to use the same key we used when creating it

```swift
print(employee["name", default: "Unknown"])
print(employee["job", default: "Unknown"])
```

The `default` value will be used if the key we have asked for does not exist.

## Sets

Sets are similar to arrays, except we cannot add duplicate items, and they do not store items in a particular order.

```swift
var numbers = Set([1, 1, 3, 5, 7])
print(numbers)
```

Adding items to a set is done by `insert()` method:

```swift
numbers.insert(10)
```

Using `contains()` on a set is effectively instant no matter how many items the set contains.

## Enums

An enum is a set of named values we can create and use to make our code more efficient ans safer.

```swift
enum Weekday {
  case monday, tuesday, wednesday, thursday, friday
}

var day = Weekday.monday
day = .friday
```

## Type annotations

We can try to force a specific type for a new variable or constant by using *type annotation*

```swift
var score: Double = 0

//other examples
let player: String = "Steph"
var luckyNumber: Int = 14
let pi: Double = 3.141
var isEnabled: Bool = true
var albums: Array<String> = ["Clouds", "Hope"]
var user: Dictionary<String, String> = ["id": "@twostraws"]
var books: Set<String> = Set(["Underdog", "Deep Learning"])
```

Arrays and dictionaries have special syntax:

```swift
var albums: [String] = ["Clouds", "Hope"]
var user: [String, String] = ["id": "@twostraws"]
```

Knowing the exact types of things is important for creating empty collections:

```swift
var teams: [String] = [String]()
var clues = [String]()
```

Values of an enum have the same type as the enum itself:

```swift
enum UIStyle {
  case light, dark, system
}

var style: UIStyle = .light
```

## Conditions

```swift
let age = 16

if age < 16 {
  print("You can't drive")
} else if age < 21 {
  print("You can't drink")
} else {
  print("You can drink now")
}
```

We can use `&&` to combine two conditions and `||` for OR condition:

```swift
let temp = 26

if temp > 20 && temp < 30 {
  print("It's a nice day.")
}
```

## Switch statements

Swift lets us check a value against multiple conditions using `switch/case` syntax

```swift
enum Weather {
  case sun, rain, wind
}

let forecast = Weather.sun

switch forecast {
  case .sun:
  	print("A nice day.")
  case .rain:
  	print("Pack an umbrealla.")
	default:
  	print("Should be okay.")
}
```

`switch` statements must be exhausive: all possible values must be handled so we can't miss one by accident.

## Ternary conditional operator

The ternary operator lets us check a condition and return one of two values

```swift
let age = 18

let canDrink = age >= 21 ? "Yes" : "No"
```

When that code runs, `canDrink` will be set to "No" because `age` is set to 18.

## Loops

`for` loop:

```swift
let platforms = ["iOS", "macOS", "tvOS", "watchOS"]

for os in platforms {
    print("Swift works on \(os).")
}
```

Loop over a range of numbers:

```swift
for i in 1...12 {
  print("5 x \(i) = \(5 * i)")
}
```

`1...12` contains the values 1 through 12 inclusive. To exclude the final number, we need to use `..<` instead:

```swift
for i in 1..<12 {
  print("5 x \(i) = \(5 * i)")
}
```

If we don't need the loop variable,

```swift
var lyric = "Haters gonna"

for _ in 1...5 {
  lyric += " hate"
}
print(lyric)
```

`while` loop:

```swift
var count = 10

while count > 0 {
  print("\(count)...")
  count -= 1
}

print("Go!")
```

We can use `continue` to skip the current loop iteration and proceed to the following one

```swift
let files = ["me.jpg", "work.txt", "sophie.jpg"]

for file in files {
  if file.hasSuffix(".jpg") == false {
    continue
  }
  print("Found picure: \(file)")
}
```

Alternatively, use `break` to exit a loop and skip all remaining iterations.

## Functions

To create a new function

```swift
func printTimesTables(number: Int) {
  for i in 1...12 {
    print("\(i) x \(number) = \(i * number)")
  }
}
printTimesTables(number: 5)
```

To return data from a function, we need to tell Swift what type it is, and then use `return` to send it back

```swift
func rollDice() -> Int {
  return Int.random(in: 1...6)
}

let result = rollDice()
print(result)
```

We can rmeove the `return` keyword if our function contains only a single line of code

```swift
func rollDice() -> Int {
  Int.random(in: 1...6)
}
```

## Returning multiple values from functions

Tuples store a fixed number of values of specific types, which is a convenient way to return multiple values from a function

```swift
func getUser() -> (firstName: String, lastName: String) {
  (firstName: "Steph", lastName: "Curry")
}

let user = getUser()
print("Name: \(user.firstName) \(user.lastName)")
```

If we don't need all the values from the tuple,

```swift
let (firstName, _) = getUser()
print("Name: \(firstName)")
```

## Customizing parameter labels

If we don't want to pass a parameter's name when calling a function, we can place an underscore before it

```swift
func isUppercase(_ string: String) -> Bool {
  stirng == string.uppercased()
}

let str = "HELLO, WORLD"
let result = isUppercase(string)
```

An alternative is to write a second name before the first: one to use externally, and one internally

```swift
func printTimesTables(for number: Int) {
  for i in 1...12 {
    print("\(i) x \(number) = \(i * number)")
  }
}

printTimesTables(for: 5)
```

In this code, `for` is used externally, and `number` is used internally.

## Providing default values for parameters

```swift
func greet(_ person: String, formal: Bool = false) {
  if format {
    print("Welcome, \(person)!")
  } else {
    print("Hi, \(person)!")
  }
}

greet("Kyrie", formal: true)
greet("Steph")
```

## Handling errors in functions

To handle errors in functions we need to tell Swift which errors can happen, write a function that can throw errors, then call it and handle any problems.

First, define the errors that can occur:

```swift
enum PasswordError: Error {
  case short, obvious
}
```

Next, write a function that can throw errors

```swift
func checkPassword(_ password: String) throws -> String {
  if password.count < 5 {
    throw PasswordError.short
  }
  if password == "12345" {
    throw PasswordError.obvious
  }
  if password.count < 10 {
    return "OK"
  } else {
    return "Good"
  }
}
```

Now we can call the throwing function by starting a `do` block, calling the function using `try`, and then catching errors that occur:

```swift
let string = "12345"

do {
  let result = try checkPassword(string)
  print("Rating: \(result)")
} catch PasswordError.obvious {
  print("I have the same combination as yours")
} catch {
  print("There was an error.")
}
```

When it comes to catching errors, we must always have a `catch` block that can handle every kind of error.

## Closures

We can assign funcationality directly to a constant or variable. For example

```swift
let sayHello = {
  print("Hi there!")
}

sayHello()
```

`sayHello` is a closure - a chunk of code we can pass around and call wheneve we want.

If we want the closure to accept parameters,

```swift
let sayHello = {
  (name: String) -> String in
  "Hi \(name)!"
}
```

The `in` is used to mark the end of the parameters and return type - everything after that is the body of the closure itself.

```swift
let team = ["Gloria", "Suzanne", "Tiffany", "Tasha"]

let onlyT = team.filter(
	{
    (name: String) -> Bool in
    return name.hasPrefix("T")
  }
)
```

Inside the closure we list the parameter `filter()` passes us, which is a string from the array. We also say that our closure returns a Boolean, then mark the start of the closure's code by using `in`.

## Trailing closures and shorthand syntax

Swift has a few tricks up its sleeve to make closures easier to read. 

For example, we start with

```swift
let team = ["Gloria", "Suzanne", "Tiffany", "Tasha"]

let onlyT = team.filter(
	{
    (name: String) -> Bool in
    return name.hasPrefix("T")
  }
)
```

The body of the closure has just a single line of code, so we can remove `return`

```swift
let onlyT = team.filter(
	{
    (name: String) -> Bool in
    name.hasPrefix("T")
  }
)
```

`filter()` must be given a function that accepts one item from its array, and returns true if it should be in the returned array. Because the function we pass in *must* behave like that, we won't need to specify the types in our closure:

```swift
let onlyT = team.filter(
	{
    name in
    name.hasPrefix("T")
  }
)
```

We can go further using special syntax called *trailing closure syntax*:

```swift
let onlyT = team.filter {
  name in
  name.hasPrefix("T")
}
```

Finally, Swift can provide short parameter names for us so we don't even write `name in` anymore, and instead rely on a specially named value provided for us: `$0`:

```swift
let onlyT = team.filter {
  $0.hasPrefix("T")
}
```

## Structs

Structs let us create our own custom data types, complete with their own properties and methods:

```swift
struct Album {
  let title: String
  let artist: String
  var isReleased = true
  
  func printSummary() {
    print("\(title) by \(artist)")
  }
}

let cloud = Album(title: "Cloud", artist: "NF")
print(cloud.title)
cloud.printSummary()
```

When we create instnaces of structs, we do so using an *initialzier* - Swift lets us treat our struct like a function. It silently generates this *memberwise initializer* based on the struct's properties.

If we want to have a strcut's method change one of its properties, we will mark it as *mutating*:

```swift
struct Album {
  let title: String
  let artist: String
  var isReleased = true
  
  func printSummary() {
    print("\(title) by \(artist)")
  }
  mutating func removeFromSale() {
    isReleased = false
  }
}
```

## Computed properties

A computed property calculates its value every time it's accessed.

For example, we can write an `Employee` struct that tracks how many days of vacation remained for that employee

```swift
struct Employee {
  let name: String
  var vacationAllocated = 14
  var vacationTaken = 0
  
  // computed property
  var vacationRemaining: Int {
    vacationAllocated - vacationTaken
  }
}
```

To be able to write to `vacationRemaining`, we need to provide both a *getter* and a *setter*:

```swift
struct Employee {
  let name: String
  var vacationAllocated = 14
  var vacationTaken = 0
  
  // computed property
  var vacationRemaining: Int {
    get {
      vacationAllocated - vacationTaken
    }
    set {
      vacationAllocated = vacationTaken + newValue
    }
  }
}
```

`newValue` is provided by Swift, and stores whatever value the user was assigning to the property.

## Property observers

Property observers run when properties change: `didSet` runs when the property just changed, and `willSet` runs *before* the property changed.

We could demonstrate `didSet` by making a `Game` struct print a message when the score changes:

```swift
struct Game {
  var score = 0 {
    didSet {
      print("Score is now \(score)")
    }
  }
}

var game = Game()

game.score += 10
game.score -= 3
```

## Custom initializers

Initializers are special functions that prepare a new struct instance to be used, ensuring all properties have an inital value. Swift generates one based on the struct's properties, but we can create our own.

```swift
struct Player {
  let name: String
  let number: Int
  
  init(name: String) {
    self.name = name
    number = Int.random(in: 1...99)
  }
}
```

## Access control

- Use `private` for "don't let anything outside the struct use this."
- Use `private(set)` for "anything outside the struct can read this, but don't let them change it."
- Use `fileprivate` for "don't let anything outside the current file use this."
- Use `public` for "let anyone, anywhere use this."

For example,

```swift
struct BankAccount {
  private(set) var funds = 0
  
  mutating func deposit(amount: Int) {
    funds += amount
  }
  
  mutating func withdraw(amount: Int) -> Bool {
    if funds > amount {
      funds -= amount
      return true
    } else {
      return false
    }
  }
}
```

Since we used `private(set)`, reading `funds` from outside the struct is fine but writing is not possible.

## Static properties and methods

Swift supports static properties and methods, allowing us to add a property or method directly to the struct itself rather than to one instance of the struct

```swift
struct AppData {
  static let version = "1.3 beta 2"
  static let settings = "settings.json"
}
```

Using this approach, everywhere we need to check or display something like the app's version we can read `AppData.version`.

## Classes

Classes let us create custom data types, and are different from structs in 5 ways.

1. We can create classes by inheriting functionality from other classes:

```swift
class Employee {
  let hours: Int
  
  init(hours: Int) {
    self.hours = hours
  }
  
  func printSummary() {
    print("I work \(hours) hours a day.")
  }
}

class Developer: Employee {
  func work() {
    print("I'm coding for \(hours) hours.")
  }
  
  // change a method from a parent class
  override func printSummary() {
    print("I spend \(hours) hours a day searching Stack Overflow")
  }
}

let novall = Developer(hours: 8)
novall.work()
novall.printSummary()
```

2. Initializers are more tricky with classes:
   1. Swift won't generate a memberwise initializer for classes.
   2. If a child class has custom initializers, it must always call the *parent's initializer* after it has finished setting up its own properties.
   3. If a subclass *doesn't* have any initializers, it automatically inherits the initializers of its parent class.

For example,

```swift
class Vehicle {
  let isElectric: Bool
  
  init(isElectric: Bool) {
    self.isElectric = isElectric
  }
}

class Car: Vehicle {
  let isConvertible: Bool
  
  init(isElectric: Bool, isConvertible: Bool) {
    self.isConvertible = isConvertible
    super.init(isElectric: isElectric)
  }
}
```

`super` allows us to call up to methods that belong to our parent class.

3. All copies of a class instance share their data, meaning that changes we make to one will automatically change other copies.

For example,

```swift
class Singer {
  var name = "Adele"
}

var singer1 = Singer()
var singer2 = singer1
singer2.name = "Eminem"
print(singer1.name)
print(singer2.name)
```

4. Classes can have a *deinitializer* that gets called when the last reference to an object is destroyed.

We could create a class that prints a message when it is created and destroyed:

```swift
class User {
  let id: Int
  
  init(id: Int) {
    self.id = id
    print("User \(id): I'm alive!")
  }
  
  deinit {
    print("User \(id): I'm dead!")
  }
}

for i in 1...3 {
  let user = User(id: i)
  print("User \(user.id): I'm in control!")
}
```

5. Classes let us change variable properties even when the class itself is constant.

```swift
class User {
  var name = "Paul"
}

let user = User()
user.name = "Steph"
print(user.name)
```

As a result of this, classes don't need the `mutating` keyword with methods that chagne their data.

## Protocols

Protocols define functionality we expect a data type to support, and Swift ensures our code follows those rules.

For example,

```swift
protocol Vehicle {
  func estimateTime(for distance: Int) -> Int
  func travel(distance: Int)
}
```

Once we have a protocol we can make data types conform to it by implementing the required functionality. For example, we could make a `Car` struct that conforms to `Vehicle`:

```swift
struct Car: Vehicle {
  func estimateTime(for distance: Int) -> Int {
    distance / 50
  }
  
  func travel(distance: Int) {
    print("I'm driving \(distance) km.")
  }
}
```

All the methods list ed in `Vehicle` must exist exactly in `Car`, with the same name, parameters, and return types.

Then we can write a function that accepts any kind of type that conforms to `Vehicle`, because Swift knows it implements both `estimateTime()` and `travel()`:

```swift
func commute(distance: Int, using vehicle: Vehicle) {
  if vehicle.estimateTime(for: distance) > 100 {
    print("Too slow!")
  } else {
    vehicle.travel(distance: distance)
  }
}

let car = Car()
commute(distance: 100, using: car)
```

Protocols can also requrie properties, so we could require properties for how many sets vehicles have and how many passengers they currently have:

```swift
protocol Vehicle {
  var name: String { get }
  var currentPassengers: Int { get set }
  func estimateTime(for distance: Int) -> Int
  func travel(distance: Int)
}
```

That adds two properties:

- one marked with `get` that might be a constant or computed property,
- one marked with `get set` that might be a variable or a computed property with a getter and setter.

Now all conforming types must add implementations of those two properties:

```swift
struct Car: Vehicle {
  let name = "Car"
  var currentPassengers = 1
  
  func estimateTime(for distance: Int) -> Int {
    distance / 50
  }
  
  func travel(distance: Int) {
    print("I'm driving \(distance) km.")
  }
}
```

## Extensions

Extensions let us add functionality to any type.

For example,

```swift
extension String {
  func trimmed() -> String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

var quote = "   The truth is rarely pure and never simple   "
let trimmed = quote.trimmed()
```

If we want to change a value directly rather than returning a new value, we need to mark our method as `mutating`:

```swift
extension String {
  func trimmed() -> String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  mutating func trim() {
    self = self.trimmed()
  }
}

quote.trim()
```

Extensions can also add computed properties to types.

```swift
extension String {
  var lines: [String] {
    self.components(separatedBy: .newlines)
  }
}

let lyrics = """
But I keep cruising
Can't stop, won't stop moving
"""

print(lyrics.lines.count)
```

The `components(separatedBy:)` method splits a string into an array of strings using a boundary of our choosing.

## Protocol extensions

Protocol extensions extend a whole protocol to add computed properties and method implementations, so any types conforming to that protocol get them.

For example, `Array`, `Dictionary`, and `Set` all conform to the `Collection` protocol, so we can add a computed property to all three of them:

```swift
extension Collection {
  var isNotEmpty: Bool {
    isEmpty == false
  }
}

let guests = ["Mario", "Luigi", "Peach"]

if guests.isNotEmpty {
    print("Guest count: \(guests.count)")
}
```

This approach means we can list required methods in a protocol, then add default implementations of those inside a protocol extension. All conforming types then get to use those default implementations, or provide their own as needed.

## Optionals

Optionals represent the absence of data.

```swift
let opposites = [
    "Mario": "Wario",
    "Luigi": "Waluigi"
]

let peachOpposite = opposites["Peach"]
```

That attempts to read the value attached to the key “Peach”, which doesn’t exist, so this can’t be a regular string.

An optional string might have a string waiting inside for us, or there might be nothing at all - a special value called `nil`, meaning "no value". Any kind of data can be optional, including `Int`, `Doule`, and `Bool`, as well as instances of enums, structs, and classes.

We need to *unwrap* the optional to use it.

```swift
if let marioOpposite = opposites["Mario"] {
  print("Mario's opposite is \(narioOpposite)")
}
```

## Unwrapping optionals with guard

`guard let` is similar to `if let` except it flips things around. `if let` runs the code inside its braces if the optional has a value, and `guard let` runs the code if the optional does not have a value.

```swift
func printSquare(of number: Int?) {
  guard let number = number else {
    print("Missing input")
    return
  }
  
  print("\(number) x \(number) is \(number * number)")
}
```

If we use `guard` to check a function's inputs are valid, Swift requires us to use `return` if the check fails.

## Nil coalescing

The *nil coalescing operator* unwraps an optional and provides a default value if the optional is empty:

```swift
let tvShows = ["Archer", "Babylon 5", "Ted Lasso"]
let favorite = tvShows.randomElement() ?? "None"
```

```swift
let input = ""
let number = Int(input) ?? 0
print(number)
```

## Optional chaining

Optional chaining reads optionals inside optionals,

```swift
let names = ["Arya", "Bran", "Robb", "Sansa"]

let chosen = names.randomElement()?.uppercased()
print("Next in line: \(chosen ?? "No one")")
```

## Optional try?

When calling a function that might throw errors, we can use `try?` to convert its result into an optional containing a value on success, or `nil` otherwise.

```swift
enum UserError: Error {
  case badID, networkFailed
}

func getUser(id: Int) throws -> String {
  throw Usererror.networkFailed
}

if let user = try? getUser(id: 14) {
  print("User: \(user)")
}
```

The `getUser()` function will always throw `networkFailed`, but we don't care what was thrown - all we care about is whether the call sent back a user or not.