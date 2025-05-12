# Day 10 - Structs, Part 1

**Structs** let us create our own data types out of several small types. For example, ew may put three strings and a Boolean together to represent a user in our app.

## Create our own structs

A simple struct looks like:

```swift
struct Album {
  let title: String
  let artist: String
  let year: Int
  
  func printSummary() {
    print("\(title) \(year) by \(artist)")
  }
}
```

This creates a new type called `Album`, with two string constants called `title` and `artist`, plus an integer constnat called `year`, with a simple print function.

In Swift convention, when we are referring to a data type, we use Camel case where the first letter is uppercased, but when we are referring to something inside the type, such as a variable or function, we use camelCase where the first letter is lowercased.

At this point, we could make a couple of albums,

```swift
let clouds = Album(title: "Clouds", artist: "NF", year: 2021)
let xposed = Album(title: "Xposed", artist: "G.E.M.", year: 2012)

print(clouds.title)
print(xposed.artist)

clouds.printSummary()
xposed.printSummary()
```

Where things get more interesting is when we want to have values that can change. For example, we could create a `Employee` struct that can take vacation as needed:

```swift
struct Employee {
  let name: String
  var vacationRemaining: Int
  
  func takeVacation(days: Int) {
    if vacationRemaining > days {
      vacationRemaining -= days
      print("I'm going on vacation!")
      print("Days remaining: \(vacationRemaining)")
    } else {
      print("Oops! There are not enough days remaining.")
    }
  }
}
```

Swift will refuse to build this struct! This is because if we create an employee as a constant using `let`, Swift makes the employee and *all its data* constant - we can call functions just fine, but those functions should NOT be allowed to change the struct's data because we made it constant.

Therefore, Swift makes us take an extra step: any functions that only read data are fine as they are, but **any that *change* data belonging to the struct must be marked with** `mutating` keyword:

```swift
struct Employee {
  let name: String
  var vacationRemaining: Int
  
  mutating func takeVacation(days: Int) {
    if vacationRemaining > days {
      vacationRemaining -= days
      print("I'm going on vacation!")
      print("Days remaining: \(vacationRemaining)")
    } else {
      print("Oops! There are not enough days remaining.")
    }
  }
}
```

Now our code will build just fine, but Swift will stop us from calling `takeVacation()` from constant structs. In code, this is allowed:

```swift
var archer = Employee(name: "Sterling Archer", vacationRemaining: 14)
archer.takeVacation(days: 5)
print(archer.vacationRemaining)
```

But if we change `var archer` to `let archer`, Swift will refuse to build our code.

Struct naming:

- Variables and constants that belong to structs are called *properties*.
- Functions that belong to structs are called *methods*.
- When we create a constant or variable out of a struct, we call that an *instance*.
- when we create instances of structs, we do so using an *initializer*, e.g., `Album(title: "Clouds", artist: "NF", year: 2021)`.

*Syntactic sugar*: Swift silently creates a speical function inside the struct called `init()`, using all the properties of the struct as its parameters. It then automatically treats these two pieces of code as being the same:

```swift
var archer1 = Employee(name: "Sterling Archer", vacationRemaining: 14)
var archer2 = Employee.init(name: "Sterling Archer", vacationRemaining: 14)
```

## Compute property values dynamically

Structs can have two kinds of properties: 

- a *stored* property - a variable or constant that holds a piece of data inside an instance of the struct
- a *computed* property - a variable that calculates the value of the property dynamically every time it is accessed

For example,

```swift
struct Employee {
    let name: String
    var vacationRemaining: Int
}

var archer = Employee(name: "Sterling Archer", vacationRemaining: 14)
archer.vacationRemaining -= 5
print(archer.vacationRemaining)
archer.vacationRemaining -= 3
print(archer.vacationRemaining)
```

This works aa a struct but we are losing how many days they were originally granted once we changed `vacationRemaining`.

We can adjust to use computed property:

```swift
struct Employee {
  let name: String
  var vacationAllocated = 14
  var vacationTaken = 0
  
  var vacationRemaining: Int {
    vacationAllocated - vacationTaken
  }
}
```

Now when we are reading from `vacationRemaining, it looks like a regular stored property:

```swift
var archer = Employee(name: "Sterling Archer", vacationAllocated: 14)
archer.vacationTaken += 4
print(archer.vacationRemaining)
archer.vacationTaken += 4
print(archer.vacationRemaining)
```

Now we are reading `vacationRemaining` like a propety but behind the scenes Swift is running some code to calculate its value every time.

We cannot *write* to it though, because we have not told Swift how that should be handled. To fix that, we need to provide both a *getter* and a *setter* - fancy names for "code that reads" and "code that writes", respectively.

```swift
struct Employee {
  let name: String
  var vacationAllocated = 14
  var vacationTaken = 0
  
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

The `get` and `set` mark individual pieces of code to run when reading our writing a value. The getter is simple and it is just our existing code. In the `set` block, the `newValue`, which is automatically provided to us by Swift, stores whatever value the user was trying to assign to the property.

With both a getter and setter in place, we can now modify `vacationRemaining`:

```swift
var archer = Employee(name: "Sterling Archer", vacationAllocated: 14)
archer.vacationTaken += 4
archer.vacationRemaining = 5
print(archer.vacationAllocated)
```

## Take action when a property changes

Swift lets us create *property observer*, which are special pieces of code that run when properties change:

- a `didSet` observer to run when the property just changed,
- a `willSet` observer to run *before* the property changed.

Consider the following example:

```swift
struct Game {
  var score = 0
}

var game = Game()
game.score += 10
print("Score is now \(game.score)")
game.score -= 3
print("Score is now \(game.score)")
game.score += 1
```

We want to print the score to track the changes everytime the score changes, but we forget to do it in the last time. With property observers we can solve this problem by attaching the `print()` call directly to the property using `didSet`, so that whenever it changes - wherever it changes - we will always run some code:

```swift
struct Game {
  var score = 0 {
    didSet {
      print("Score is not \(score)")
    }
  }
}

var game = Game()
game.score += 10
game.score -= 3
game.score += 1
```

If we want it, Swift automatically provides the constant `oldValue` inside `didSet`, in case we need to have custom functionality based on what we were changing from.

There is also a `willSet` variant that runs some code *before* the property changes, which in turn provides the new value that will be assigned in case we want to take different action based on that. For example,

```swift
struct App {
  var contacts = [String]() {
    willSet {
      print("Current value is: \(contacts)")
      print("New value will be: \(newValue)")
    }
    
    didSet {
      print("There are now \(contacts.count) contacts.")
      print("Old value was \(oldValue)")
    }
  }
}

var app = App()
app.contacts.append("Steph C")
app.contacts.append("Kyrie I")
app.contacts.append("Derrick R")
```

Appending to an array will trigger both `willSet` and `didSet`, so that code will print lots of text when run. In practice, `willSet` is used much less than `didSet`. The property observers let us attach functionality to be run before or after a property is changed, using `willSet` and `didSet`, respectively.



# Create custom initializers

Initializers are specialized methods that are designed to prepare a new struct instance to be used. We can allow Swift silently generates one for us based on the properties we place inside a struct, but we can also create our own as long as we follow one golden rule: all properties must have a value by the time the initializer ends.

The Swift's default initializer for structs:

```swift
struct Player {
  let name: String
  let number: Int
}

let player = Player(name: "Steph C", number: 30)
```

This creates a new `Player` instance by providing values for its two properties. Swift calls this the *memberwise initializer*, which is a fancy way of saying an intiializer that accepts each property in the order it was defined.

If we want to write the initializers to do the same thing, we must be careful to distinguish between the names of parameters coming in and the names of properties being assign:

```swift
struct Player {
  let name: String
  let number: Int
  
  init(name: String, number: Int) {
    self.name = name
    self.number = number
  }
}
```

This works the same as our previous code, except now the initializer is owned by us so we can add extra functionality there if needed. We have used `self` to assign parameters to properties to clarify we mean "assign the `name` parameter to my `name` property".

Our custom initializers do not need to work like the default memberwise initializer Swift provides us with. For example, we could say that we must provide a player name, but the shirt number is randomized:

```swift
struct Player {
  let name: String
  let number: Int
  
  init(name: String) {
    self.name = name
    number = Int.random(in 1...99)
  }
}

let player = Player(name: "Steph C")
print(player.number)
```

Again, all properties must have a value by the time the initializer ends.

If any of our properties have default values, they will be incorporated into the initializer as default parameter values. So, if we make a struct like this:

```swift
struct Employee {
  var name: String
  var yearsActive = 0
}
```

Then we can create it in two ways:

```swift
let steph = Employee(name: "Steph Curry")
let kyrie = Employee(name: "Kyrie Ivring", yearsActive: 13)
```

Swift also *removes* the memberwise initializer if we create an initializer of our own. For example, if we have a custom initializer that created anonymous employees,

```swift
struct Employee {
  var name: String
  var yearsActive = 0
  
  init() {
    self.name = "Anonymous"
    print("Creating an anonymous employee...")
  }
}
```

With that in place, we could not rely on the memberwise initializer, so the following will not be allowed:

```swift
let steph = Employee(name: "Steph Curry")
```

Since we created our own initializer, the default memberwise initializer goes away. If we want it to stay, we need to move our custom initializer to an extension:

```swift
struct Employee {
  var name: String
  var yearsActive = 0
}

extension Employee {
  init() {
    self.name = "Anonymous"
    print("Creating an anonymous employee...")
  }
}

// Creating a named employee now works
let derrick = Employee(name: "Derrick Rose")

// as does creating an anonymous employee
let anon = Employee()
```

The main reason for using `self` inside an initializer is to match parameter names to the property names of our type.  For example,

```swift
struct Student {
  var name: String
  var bestFriend: String
  
  init(name: String, bestFriend: String) {
    print("Enrolling \(name) in class...")
    self.name = name
    self.bestFriend = bestFriend
  }
}
```

Outisde of initializers, the main reason for using `self` is because we are in a closure and Swift requires it so we are clear we understand what is happening.