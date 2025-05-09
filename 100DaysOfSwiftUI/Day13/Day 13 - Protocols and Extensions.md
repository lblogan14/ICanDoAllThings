# Day 13 - Protocols and Extensions

## Create and use protocols

Protocols in Swift let us define what kinds of functionality we expect a data type to support, and Swift ensures that the rest of our code follows those rules.

Protocols let us define a series of properties and methods that we want to use. They do not implement those properties and methods - they do not actually put any code behind it - they just say that the properties and methods must exist, like a blueprint.

For example, we could define a new `Vehicle` protocol:

```swift
protocol Vehicle {
  func estimateTime(for distance: Int) -> Int
  func travel(distance: Int)
}
```

- To create a new protocol, we write `protocol` followed by the protocol name.
- Inside the protocol, we list all the methods we require in order for this protocol to work the way we expect.
- These methods do not contain any code inside - there are no function bodies provided here. Instead we specify the method names, parameters, and return types. We can also mark methods as being throwing or mutating if needed.

After creating the protocol, we can create new structs, classes, or enums that implement the requirements for that protocol, which is a process called *adopting* or *conforming* to the protocol.

The protocol does not specify the full range of functionality that must exist, only a bare minimum. When we create new types that conform to the protocol, we can add all sorts of other properties and methods as needed. For example, we could make a `Car` struct that conforms to `Vehicle`:

```swift
struct Car: Vehicle {
  func estimateTime(for distance: Int) -> Int {
    distance / 50
  }
  
  func travel(distance: Int) {
    print("I'm driving \(distance) km.")
  }
  
  func openSunroof() {
    print("It's a nice day!")
  }
}
```

- `Car` conforms to `Vehicle` by using a colon (`:`) after the name `Car`, just like how we mark subclasses.
- All the methods we listed in `Vehicle` must exist *exactly* in `Car`.
- The methods in `Car` provide actual implementations of the methods we define in the protocol.
- The `openSunroof()` method does not come from the `Vehicle` protocol, but that is totally okay.

Now we can implement a `commute()` function:

```swift
func commute(distance: Int, using vehicle: Vehicle) {
  if vehicle.estimateTime(for: distance) > 100 {
    print("That's too slow! I'll try a different vehicle.")
  } else {
    vehicle.travel(distance: distance)
  }
}

let car = Car()
commute(distance: 100, using: car)
```

We can see that the `commute()` function can be called with any type of data, as long as that type conforms to the `Vehicle` protocol. The body of the function does not need to change, because Swift knows for sure that the `estimateTime()` and `travel()` methods exist.

Now we can create a `Bicycle` strcut:

```swift
struct Bicycle: Vehicle {
  func estimateTime(for distance: Int) -> Int {
    distance / 10
  }
  
  func travel(distance: Int) {
    print("I'm cycling \(distance) km.")
  }
}

let bike = Bicycle()
commute(distance: 50, using: bike)
```

This is where the power of protocols becomes apparent: we can now either pass a `Car` or a `Bicycle` into the `commute()` function.

In addition to methods, we can also write protocols to describe *properties* that must exist on conforming types. For example, we could specify that all types that conform `Vehicle` must specify its name and how many passengers they currently have:

```swift
protocol Vehicle {
  var name: String { get }
  var currentPassengers: Int { get set }
  func estimateTime(for distance: Int) -> Int
  func travel(distance: Int)
}
```

- A string called `name`, which must be readable. That might mean it's a constant, but it might also be a computed property with a getter.
- An integer called `currentPassengers`, which must be read-write. That might mean it's a variable, but it might also be a computed propety with a getter and setter.

Type annotation is required for both of them, because we cannot provide a default value in a protocol. Now we need to update our `Car` and `Bicycle` structs:

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
  
  func openSunroof() {
    print("It's a nice day!")
  }
}


struct Bicycle: Vehicle {
  let name = "Bicycle"
  var currentPassengers = 1
  
  func estimateTime(for distance: Int) -> Int {
    distance / 10
  }
  
  func travel(distance: Int) {
    print("I'm cycling \(distance) km.")
  }
}
```

We could write a method tha accepts an array of vehicles and uses it to calculate estimates across a range of options:

```swift
func getTravelEstimates(using vehicles: [Vehicle], distance: Int) {
  for vehicle in vehicles {
    let estimate = vehicle.estimateTime(for: distance)
    print("\(vehicle.name): \(estimate) hours to travel \(distance) km.")
  }
}

getTravelEstimates(using: [car, bike], distance: 150)
```

## Use opaque return types

*Opaque return types* let us remove complexity in our code.

```swift
func getRandomNumber() -> Int {
  Int.random(in: 1...6)
}

func getRandomBool() -> Bool {
  Bool.random()
}
```

`getRandomNumber()` returns a random integer, and `getRandomBool()` returns a random Boolean. Both `Int` and `Bool` conform to a common Swift protocol called `Equatable`, which means "can be compared for equality"

The `Equatable` protocol allows us to use `==`:

```swift
print(getRanomNumber() == getRandomNumber())
```

Because both of these types conform to `Equatable`, we could try amending our function to return an `Equatable` value:

```swift
func getRandomNumber() -> Equatable {
  Int.random(in: 1...6)
}

func getRandomBool() -> Equatable {
  Bool.random()
}
```

NOTE: **ERROR**: "protocol 'Equatable' can only be used as a generic constraint because it has Self or associated type requirements".

The main reason of this error is because `Int` and `Bool` are NOT interchangeable - we cannot use `==` to compare an `Int` and a `Bool`.

Returning a protocol from a function is useful because it lets us hide information: rather than stating the exact type that is being returned, we get to focus on the *funcationality* that is returned. Suppose we have a `Vehicle` protocol which may report back the number of seats, the approximate fuel usage, and a price. This means that we can change our code later without breaking things: we could return a `RaceCar` or a `PickUpTruck`, etc, as long as they implement the properties and methods required by `Vehicle`.

Hiding information in this way is really useful, but it just is not possible with `Equatable` because it is not possible to compare two different `Equatable` things. Even if we call `getRandomNumber()` twice to get two integers, we cannot compare them because we have hidden their exact data type - we have hidden the fact that they are two integers that actually could be compared.

This is where **opaque return types** come in: they let us hide information in our code, but not from the Swift compiler. To upgrade our two functions to opaque return types, we need to add the `some` keyword before their return type:

```swift
func getRandomNumber() -> some Equatable {
  Int.random(in: 1...6)
}

func getRandomBool() -> some Equatable {
  Bool.random()
}

// no error
print(getRanomNumber() == getRandomNumber())
```

This time, Swift knows that behind the scenes they are actually two integers.

Returning an opaque return type means we still get to focus on the functionality we want to return rather than the specific type, which in turn allows us to change our mind in the future without breaking the rest of our code. For example, we can switch to `Double.random()` and the code still works.

In the case of `Vehicle`, returning `Vehicle` means "any sort of Vehicle type but we don't know what", while returning `some Vehicle` means "a specific sort of `Vehicle` type but we don't want to say which one."

## Create and use extensions

**Extensions** let us add functionality to any type, whether we created it or someone else created it - even one of Apple's own types.

For example, the `trimmingCharacters(in: )` method removes certain kinds of characters from the start or end of a string, such as alphanumeric letters, decimal digits, or whitespaces nad newlines.

*Whitespace* is the general term of the space character, the tab character, and a variety of other variants. Newlines are line breaks in text.

For example,

```swift
var quote = "   The truth is rarely pure and never simple   "
```

We can trim the whitespace and newlines on either side:

```swift
let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)
```

The `.whitespacesAndNewlines` value comes from Apple's Foundation API, so does `trimmingCharacters(in:)`. Foundation is packed with useful code!

Having to call `trimmingCharacters(in: )` every time is a bit wordy, so we can write an extension to make it shorter:

```swift
extension String {
  func trimmed() -> String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
```

- We start with `extension` keyword to tell Swift we want to add functionality to an existing type.
- We want to add functionality to `String`
- We add a new method called `trimmed()` which returns a new string
- Inside we call `trimmingCharacters(in: )`
- We use `self` here - this automatically refers to the current string. This is possible because we are currently in a string extension.

Now if we want to remove whitespace and newlines:

```swift
let trimmed = quote.trimmed()
```

We could also implement a function to do the same thing:

```swift
func trim(_ string: String) -> String {
  string.trimmingCharacters(in: .whitespacesAndNewlines)
}

let trimmed_f = trim(quote)
```

This kind of function is called a *global function* because it is available everything in our project. However, the extension has a number of benefits over the global function:

1. When we type `quote.` Xcode brings up a list of methods on the string, including all the ones we add in extensions.
2. Writing global functions makes our code rather messy. On the other hand, extensions are naturally goruped by the data type they are extending.
3. Because our extension methdos are a full part of the original type, they get full access to the types's intenral data. That means they are use properties and methods marked with `private` access conttrol.

In addition, extensions make it easier to modify values in place, i.e., to change a value directly, rather than return a new value. For example, the `trimmed()` method our extension returns a new string with whitespace and newlines removed, but if we want to modify the string *directly*, we could add a new function to the extension:

```swift
extension String {
  func trimmed() -> String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  mutating func trim() {
    self = self.trimmed()
  }
}

var quote = "   The truth is rarely pure and never simple   "
// trim in place now
quote.trim()
print(quote)
```

Naming convention: when we return a new value we used `trimmed()`, but when we modified the string directly we used `trim()`.

If we are returning a new value rather than changing it in place, we hsould use word endings like `ed` or `ing`, like `reversed()`.

We can also use extensions to add *properties* to types, but here is one rule: they must only be *computed properties*, not stored properties. This is because adding new stored properties would affect the actual size of the data types.

For example, We can add a `lines` property to strings, which breaks the string up into an array of individual lines. This wraps a string method called `components(separatedBy: )`, which breaks the string up into a string array by splitting it on a boundary of our choosing.

```swift
extension String {
    var lines: [String] {
      self.components(separatedBy: .newlines)
    }
}

let lyrics = """
But I keep cruising
Can't stop, won't stop moving
It's like I got this music in my mind
Saying it's gonna be alright
"""

print(lyrics.lines.count)
```

Another example:

```swift
struct Book {
  let title: String
  let pageCount: Int
  let readingHours: Int
}

let lotr = Book(title: "Lord of the Rings", pageCount: 1178, readingHours: 24)
```

We can create our own initializer:

```swift
struct Book {
  let title: String
  let pageCount: Int
  let readingHours: Int
  
  init(title: String, pageCount: Int) {
    self.title = title
    self.pageCount = pageCount
    self.readingHours = pageCount / 50
  }
}
```

If Swift keeps the memberwise initializer in this instance, it will skip our logic for calculating the approximate reading time.

If we implement a custom initializer inside an extension, then Swift will NOT disable the automatic memberwise initializer. So, if we want our `Book` struct to have the default memberwise initializer as well as our custom initializer, we would place the custom one in an extension:

```swift
extension Book {
  init(title: String, pageCount: Int) {
    self.title = title
    self.pageCount = pageCount
    self.readingHours = pageCount / 50
  }
}
```

## Create and use protocol extensions

**Protocols** let us define contracts that conforming types must adhere to, and **extensions** let us add functionality to existing types.

*Protocol extensions* are used to extend a whole protocol to add method implementations, meaning that any types conforming to that protocol get those methods.

For example,

```swift
let guests = ["Mario", "Luigi", "Peach"]

if guests.isEmpty == false {
  print("Guest count: \(guests.count)")
}
```

Some people prefer `!`:

```swift
if !guests.isEmpty {
  print("Guest count: \(guests.count)")
}
```

But either of those are nautrally readable. We can fix with a simple extension for `Array`:

```swift
extension Array {
  var isNotEmpty: Bool {
    isEmpty == false
  }
}

let guests = ["Mario", "Luigi", "Peach"]
if guests.isNotEmpty {
  print("Guest count: \(guests.count)")
}
```

We can do better since we still have `Set` and `Dictionary` to add this extension. If we do not want to repeat ourself and copy the code into extensions, we could see that `Array`, `Set` and `Dictionary` all conform to a built-in protocol called `Collection`, through which they get functionality such as `contains()`, `sorted()`, `reversed()`, and more.

`Collection` also requries the `isEmpty` property to exist:

```swift
extension Collection {
  var isNotEmpty: Bool {
    isEmpty == false
  }
}
```

Now we can use `isNotEmpty` on arrays, sets, and dictionaries, as well as any other types that conform to `Collection`.

More importantly, by extending the protocol we are adding functionality that would otherwise need to be done inside individual structs. This leads to *protocol-oriented programming* in Apple - we can list some required methods in a protocol, then add default implementations of those inside a protocol extension. All conforming types then get to use those default implementations, or provide their own as needed.

For example,

```swift
protocol Person {
  var name: String { get }
  func sayHello()
}
```

This means all conforming types must add a `sayHello()` method, but we can also add a default implementation of that as an extension:

```swift
extension Person {
  func sayHello() {
    print("Hi, I'm \(name)")
  }
}
```

And now conforming types can add their own `sayHello`()` method if they want, but they don't need to - they can always rely on the one provided inside our protocol extension.

Hence, we could create an employee without the `sayHello()` method:

```swift
struct Employee: Person {
  let name: String
}
```

but because it conforms to `Person`, we could use the default implementation we provided in our extension:

```swift
let steph = Employee(name: "Steph Curry")
steph.sayHello()
```

