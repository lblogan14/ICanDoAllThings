# Day 11 - Structs, Part 2

As we did in Day 10, structs let us combine individual pieces of data to make something new, then attach methods so we can manipulate that data.

## Limit access to internal data using access control

By default, Swift'ss structs let us access their properties and methods freely, but often that is not what we want - sometimes we want to hide some data from external access. We can demonstrate the problem with an example:

```swift
struct BankAccount {
  var funds = 0
  
  mutating func deposit(amount: Int) {
    funds += amount
  }
  
  mutating func withdraw(amount: Int) -> Bool {
    if funds >= amount {
      funds -= amount
      return true
    } else {
      return false
    }
  }
}
```

This struct has methods to deposite and withdraw money from a bank account, and should be used like:

```swift
var account = BankAccount()
account.deposit(amount: 100)

let success = account.withdraw(amount: 200)

if success {
  print("Withdrew money successfully")
} else {
  print("Failed to get the money")
}
```

But the `funds` property is exposed to us externally, and we can directly modify its value:

```swift
account.funds -= 1000
```

This completely bypasses the logic we put in place and our program could behave in weird days. To solve this, we can tell Swift that `funds` should be accessible only inside the struct - by methods that belong to the struct, as well as any computed properties, property observers, and so on. This takes only one extra keyword:

```swift
private var funds = 0
```

And the complete new struct should look like

```swift
struct BankAccount {
  // funds is private now
  private var funds = 0
  
  mutating func deposit(amount: Int) {
    funds += amount
  }
  
  mutating func withdraw(amount: Int) -> Bool {
    if funds >= amount {
      funds -= amount
      return true
    } else {
      return false
    }
  }
}
```

Now accessing `funds` from outside the struct is not possible, but it is *possible* inside both `deposit()` and `withdraw()`.

This is called **access control**, because it controls how a struct's properties and methods can be accessed from outside the struct.

Swift provides us with several options:

- `private` for "don't let anything outside the struct use this."
- `fileprivate` for "don't let anything outside the current file use this."
- `public` for "let anyone, anywhere use this."

There is one extra option: `private(set)`, which means "let anyone read this property, but only let my methods write it." If we want to use it in `BankAccount`, it would mean that we could print `account.funds` outside of the struct, but only `deposit()` and `withdraw()` could actually *change the value*.

## Static properties and methods

Sometimes we want to add a property or method to the struct itself, rather than to one particular instance of the struct, which allows us to use them directly.

This can be used to create example data and store fixed data that needs to be accessed in various places. For example, the following struct is used to create and use static properties and methods:

```swift
struct School {
  static var studentCount = 0
  
  static func add(student: String) {
    print("\(student) joined the school.")
    studentCount += 1
  }
}
```

The keyword `static` means both the `studentCount` property and `add()` method belong to the `School` struct itself, rather than to individual instances of the struct. To use that code, we should write:

```swift
School.add(student: "Steph Curry")
print(School.studentCount)
```

We have not created an instance of `School` but we can literally use `add()` and `studentCount` directly on the struct, because those are both static, which means they do not exist uniquely on instances of the struct.

This should also explain why we are able to modify the `studentCount` property without marking the method as `mutating` - that is only needed with regular struct functions for times when an instance of struct was created as a constant, and there is no instance when calling `add()`.

If we choose to mix and match static and non-static properties and methods, there are two rules:

1. To access non-static code from static code, we cannot do that: static properties and methods cannot refer to non-static properties and methdos because it just does not make sense - which instance of `School` would we be referring to?
2. To access static code from non-static code, we always use our type's name such as `School.studentCount`. We can also use `Self` to refer to the current type.

Now we have `self` and `Self`:

- `self` refers to the current value of the struct,
- `Self` refers to the current *type*.

Think about `Self` is just like the rest of Swift's naming - we start all our data types with a capital letter (`Int`, `Double`, `Bool`, etc), so it makes sense for `Self` to start with a capital letter too.

We can use static properties to organize common data in our apps. For example, we may have a struct like `AppData` to store lots of shared avlues we use in many places:

```swift
struct AppData {
  static let version = "1.3 beta 2"
  static let saveFilename = "settings.json"
  static let homeURL = "https://www.hackingwithswift.com"
}
```

Using this approach, everywhere I need to check or display something like the app's version number, screen, debug output, logging information, support emails, etc, we can just read `AppData.version`.

The second example of using static data is to create examples of our structs. SwiftUI works best when it can show previews of our app as we develop, and those previews often require sample data.

For example, if we are showing a screen that displays data on one employee, we will want to be able to show an example employee in the preview screen so we can check it all looks correct as we work:

```swift
struct Employee {
  let username: String
  let password: String
  
  static let example = Employee(
  	username: "kai11",
    password: "artistonthecourt"
  )
}
```

Whenever we need an `Employee` instance to work with in our design previews, we can use `Employee.example` and we are done.

