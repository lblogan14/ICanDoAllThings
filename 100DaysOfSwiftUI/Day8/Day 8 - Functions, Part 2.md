# Day 8 - Functions, Part 2

## Provide default values for parameters

Adding parameters to functions lets us add customization points, so that functions can operate on different data depending on our needs.

Previously, we have this:

```swift
func printTimesTables(for number: Int, end: Int) {
  for i in 1...end {
    print("\(i) x \(number) is \(i * number)")
  }
}

printTimesTables(for: 5, end: 20)
```

We may want to leave a default value for the `end` parameter.

```swift
func printTimesTables(for number: Int, end: Int = 12) {
  for i in 1...end {
    print("\(i) x \(number) is \(i * number)")
  }
}

printTimesTables(for: 5, end: 20)
printTimesTables(for: 8)
```

We have seen a default parameter in action before:

```swift
var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)
characters.removeAll()
print(characters.count)
```

For performance optimization, Swift gives arrays just enough memory to hold their items plus a litte extra so they can grow a little over time. When we call `removeAll()`, Swift will automatically remvoe all the items in the array, then free up all the memory that was assigned to the array. However, if we want to remove the items while keeping the previous capacity:

```swift
characters.removeAll(keepingCapacity: true)
```

`keepingCapacity` is Boolean with the default value of `false` so that it does the sensible thing by default.

## Handle errors in functions

If the user asks us to check how strong their password is, we will flag up a serious error if the password is too short or is obvious. We need to start by defining the possible errors that might happen. This means making a new `enum` that builds on Swift's existing `Error` type:

```swift
enum PasswordError: Error {
  case short, obvious
}
```

That says there are two possible errors with password: `short` and `obvious`. It does not define what those *mean*, only that they exist.

Then we need to write a function that will trigger one of those errors. In our case, we will write a function that checks the strengths of a password: if it is really bad - fewer than 5 characters or is extremely well known - then we will throw an error immediately, but for all other strings we will reutrn either "OK", "Good", or "Excellent" ratings.

```swift
func checkPassword(_ password: String) throws -> String {
  if password.count < 5 {
    throw PasswordError.short
  }
  
  if password == "12345" {
    throw PasswordError.obvious
  }
  
  if password.count < 8 {
    return "OK"
  } else if password.count < 10 {
    return "Good"
  } else {
    return "Excellent"
  }
}
```

- If a function is able to throw errors **without handling them itself**, we must mark the function as `throws` before the return type.
- We do not specify exactly what kind of error is thrown by the function, just that it can throw errors.
- Being marked with `throws` does not mean the function *must* throw errors, only that it might.
- When it comes to throw an error, we write `throw` followed by one of our `PasswordError` cases. This immediately exits the function, meaning that it will not return a string.
- If no errors are thrown, the function must behave like normal.

The final step is to run the function and handle any errors that might happen. When it comes to working with Swift projects, we will find there are three steps:

1. Starting a block of work that might throw errors, using `do`.
2. Calling one or more throwing functions, using `try`.
3. Handling any thrown errors using `catch`.

In pseudocode,

```swift
do {
  try someRiskyWork()
} catch {
  print("Handle errors here")
}
```

This is applied:

```swift
let pw = "12345"

do {
  let result = try checkPassword(pw)
  print("Password rating: \(result)")
} catch {
  print("There was an error.")
}
```

If the `checkPassword()` works correctly, it will return a value into `result`. If any errors are thrown, the password rating message will never be printed - execution will immediately jump to the `catch` block.

The `try` keyword must be written before calling all functions that might throw errors, and is a visual signal to developers that regular code execution will be interrupted if an error happens.

When we use `try`, we need to be inside a `do` block, and make sure we have one or more `catch` blocks able to handle any errors.

when it comes to catching errors, we must always have a `catch` block that is able to handle every kind of error. However, we can also catch specific errors as well:

```swift
let pw = "12345"

do {
  let result = try checkPassword(pw)
  print("Password rating: \(result)")
} catch PasswordError.short {
  print("Please use a longer password.")
} catch PasswordError.obvious {
  print("I have the same combination on my luggage!")
} catch {
  print("There was an error.")
}
```

Most errors thrown by Apple provide a meaningful message that we can present to our user if needed. Swift makes this available using an `error` value that is automatically provided inside our `catch` block, and it is common to read `error.localizedDescription` to see exactly what happened.



Using Swift’s throwing functions relies on three unique keywords: `do`, `try`, and `catch`. We need all three to be able to call a throwing function. By forcing us to use `try` before every throwing function, we are explicitly acknowledging which parts of our code can cause errors. This is useful if we have several throwing functions in a single `do` block:

```swift
do {
    try throwingFunction1()
    nonThrowingFunction1()
    try throwingFunction2()
    nonThrowingFunction2()
    try throwingFunction3()
} catch {
    // handle errors
}
```