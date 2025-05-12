# Day 12 - Classes

**Classes** are similar to structs because we use them to create new data types with properties and methods. However, classes introduce a new, important, and complex feature called *inheritance* - the ability to make one class build on the foundation of another.

## Create Our Own Classes

Swift uses structs for storing most of its data types, including `String`, `Int`, `Double`, and `Array`.

Similarities between classes and structs:

- We get to create and name them.
- We can add properties and methods, including property observers and access control.
- We can create custom initializers to configure new instances however we want.

Differences:

- We can make one class build upon functionality in another class, gaining all its properties and methods as a starting point. If we want to selectively override some methods, we can do that too.
- Because of the first point, Swift will NOT automatically generate a memberwise initializer for classes. This means that we either need to write our own initializer, or assign default values to all our properties.
- When we copy an instance of a class, both copies share the same data - if we change one copy, the other one also changes.
- When the final copy of a class instance is destroyed, Swift can optionally run a special function called a *deinitializer*.
- Even if we make a class constant, we can still change its properties as long as they are variables.

SwiftUI uses classes extensively, mainly for the Point 3: all copies of a class share the same data. This means many parts of our app can share the same information, so that if the user chagned their name in one screen all the other screens would automatically update to reflect that change.

A toy class example:

```swift
class Game {
  var score = 0 {
    didSet {
      print("Score is now \(score)")
    }
  }
}

var newGame = Game()
newGame.score += 10
```

## Make One Class Inherit from Another

Swift lets us create classes by basing them on existing classes, which is called *inheritance*. To make one class inherit from another, we write a colon after the child class's name, then add the parent class's name. For example,

```swift
// parent class
class Employee {
  let hours: Int
  
  init(hours: Int) {
    self.hours = hours
  }
}

// children classes
class Developer: Employee {
  func work() {
    print("I'm writing code for \(hours) hours.")
  }
}

class Manager: Employee {
  func work() {
    print("I'm going to meetings for \(hours) hours.")
  }
}
```

Both children classes can refer directly to `hours`. Each of those classes inherit from `Employee`, but each then adds their own customization.
```swift
let robert = Developer(hours: 8)
let joe = Manager(hours: 10)

robert.work()
joe.work()
```

As well as sharing properties, we can also share methods, which can then be called from the child classes. For example,

```swift
// parent class
class Employee {
  let hours: Int
  
  func printSummary() {
    print("I work \(hours) hours a day.")
  }
  
  init(hours: Int) {
    self.hours = hours
  }
}
```

Because `Developer` inherits from `Employee`, we can immediately start calling `printSummary()` on instances of `Developer`,

```swift
let nova = Developer(hours: 8)
nova.printSummary()
```

If a child class wants to change a method from a parent class, we must use `override` in the  child class. For example,

```swift
class Developer: Employee {
  func work() {
    print("I'm writing code for \(hours) hours.")
  }
  
  override func printSummary() {
    print("I'm a developer who will sometimes work \(hours) hours a day, but other times spend hours arguing about whether code should be indented using tab or spaces.")
  }
}
```

Final classes are ones that cannot be inherited from, which means it is not possible for users of our code to add functionality or change what they have. This is not the default: we must opt in to this behavior by adding the `final` keyword to our class.

```swift
final class Manager: Employee {
  func work() {
    print("I'm going to meetings for \(hours) hours.")
  }
}
```

## Add Initializers for Classes

Swift will not automatically generate a memberwise initializer for classes. We either need to write our own initializer, or provide default values for all the properties of the class.

```swift
class Vehicle {
  let isElectric: Bool
  
  init(isElectic: Bool) {
    self.isElectric = isElectric
  }
}
```

This class has a single Boolean property, plus an initializer to set the value for that property. Using `self` makes it clear we are assigning the `isElectric` parameter to the property of the same name.

Now if we want to make a `Car` class inheriting from `Vehicle`, we have to provide `Car` with an initializer that includes both `isElectric` and its own parameters.

```swift
class Car: Vehicle {
  let isConvertible: Bool
  
  init(isElectric: Bool, isConvertible: Bool) {
    self.isConvertible = isConvertible
    super.init(isElectric: isElectric)
  }
}
```

`super` allows us to call up to methods that belong to our parent class, such as its initializer. We can use it with other methods if we want, it is not limited to initializers.

Now that we have a valid initializer in both our classes, we can make an instance of `Car`:

```swift
let teslaX = Car(isElectric: true, isConvertible: false)
```

If a subclass does not have any of its own initializers, it automatically inherits the initailizers of its parent class.

## Copy Classes

In Swift, all copies of a class instance share the same data, meaning that any changes we make to one copy will automatically change the other copies. This happens because classes are *reference types* in Swift, which means all copies of a class all *refer* back to the same underlying pot of data.

We start with a simple class:

```swift
class User {
  var username = "Anonymous"
}
```

This just has one property, but because it is stored inside a class, it will get shared across all copies of the class.

```swift
var user1 = User()

// take a copy
var user2 = user1
user2.username = "Steph"

// check results
print(user1.username)
print(user2.username)
```

In comparison, structs do NOT share their data amongst copies, meaning that if we change `class User` to `struct User` in our code, we will get a different result:

```swift
struct User {
  var username = "Anonymous"
}

var user1 = User()

// take a copy
var user2 = user1
user2.username = "Steph"

// check results
print(user1.username)
print(user2.username)
```

If we really want to create a *unique* copy of a class instance - sometimes called a *deep copy* - we need to handle creating a new instance and copy across all our data safely:

```swift
class User {
  var username = "Anonymous"
  
  func copy() -> User {
    let user = User()
    user.username = username
    return user
  }
}
```

The `copy()` method allows us to safely get an object with the same starting data, but any future changes will NOT impact the original.

## Create a Deinitializer for a Class

Swift's classes can optionally be given a *deinitializer*, which gets called when the object is *destroyed*. Exactly when our deinitializers are called depends on what we are doing, but it really comes down to a concept called *scope*. Scope means "the context where information is available":

- If we create a variable inside a function, we cannot access it from outside the function.
- If we create a variable inside an `if` condition, that variable is not available outside the condition.
- If we create a variable inside a `for` loop, including the loop variable itself, we cannot use it outside the loop.

If we look at the big picture, we can see each of those use braces to create their scope: conditions, loops, and functions all create local scopes.

When a value exits scope we mean the context it was created in is going away. In the case of structs that means the data is being destroyed, but in the case of classes it means only one copy of the underlying data is going away - there might still be other copies elsewhere.

When the final copy goes away - when the last constant or variable pointing at a class instance is destroyed - then the underlying data is also destroyed, and the memory it was using is returned back to the system.

For example, we can create a class that prints a message when it is created and destroyed, using an initializer and deinitializer:

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
```

Now we can create and destroy instances of that quickly using a loop:

```swift
for i in 1...3 {
  let user = User(id: i)
  print("User \(user.id): I'm in control!")
}
```

The output is

```
User 1: I'm alive!
User 1: I'm in control!
User 1: I'm dead!
User 2: I'm alive!
User 2: I'm in control!
User 2: I'm dead!
User 3: I'm alive!
User 3: I'm in control!
User 3: I'm dead!
```

The deinitializer is only called when the last remaining reference to a class instance is destroyed. There may be a variable or constant we have stashed away, or perhaps we store something in an array.

For example, if we add our `User` instances as they are created, they would only be destroyed when the array is cleared:

```swift
var users = [User]()

for i in 1...3 {
  let user = User(id: i)
  print("User \(user.id): I'm in control!")
  users.append(user)
}

print("Loop is finished!")
users.removeAll()
print("Array is clear!")
```

The output in the terminal is

```
User 1: I'm alive!
User 1: I'm in control!
User 2: I'm alive!
User 2: I'm in control!
User 3: I'm alive!
User 3: I'm in control!
Loop is finished!
User 1: I'm dead!
User 2: I'm dead!
User 3: I'm dead!
Array is clear!
```

## Work with Variables inside Classes

```swift
class User {
    var name = "Paul"
}

let user = User()
user.name = "Taylor"
print(user.name)
```

The data inside the class has changed, but the class instance itself - the object we created - has not changed, and in fact it cannot be changed because we made it constant: `let user = User()`. So the class instance in this case is a constant but the `name` property inside the `User` class is a variable.

```swift
class User {
  var name = "Steph"
}

var user = User()
user.name = "Kyrie"
print(user.name)
user = User()
print(user.name)
```

Now the class instance is a variable and we can override with a new instance.

Therefore, we have 4 options:

- Constant instance, constant property
- Constant instance, variable property
- Variable instance, constant property
- Variable instance, variable property

Between classes and structs:

- Variable classes can have variable properties changed.
- Constant classes can have variable properties changed.
- Variable structs can ahve variable properties change.
- Constant structs **CANNOT** have variable properties changed.

The reason for this lies in the fundamental difference between a class and a struct: one points to some data in memory, whereas the other is one value such as the number 5.