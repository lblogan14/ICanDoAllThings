# Day 14 - Optionals

*Null references* are variables which has no value

## Handle missing data with optionals

```swift
let opposites = [
  "Mario": "Wario",
  "Luigi": "Waluigi"
]

let peachOpposite = opposites["Peach"]
```

The `[String: String]` dictionary does not have  the key `"Peach"` and will throw an error.

Swift's solution is called *optionals*, which means data that may be present or may not. They are primarily represented by placing a question mark after our data type, so in this case `peachOpposite` would be a `String?` rather than a `String`.

A `String?` means threre might be a string waiting inside for us, or there might be nothing at all - a special value called `nil`, that means "no value". Any kind of data can be optional, including `Int`, `Double`, and `Bool`, as well as instances of enums, strcuts, and classes.

Swift likes our code to be predictable, which means it will NOT let us use data that might not be there. In the case of optionals, that means we need to *unwrap* the optional in order to use it - we need to look inside the box to see if there is a value.

One way to unwrap optionals is:

```swift
if let marioOpposite = opposites["Mario"] {
  print("Mario's opposite is \(marioOpposite)")
}
```

The `if let` combines creating a condition (`if`) with creating a constant (`let`). The condition's body will only be run if the optionals had a value inside. We also want to add an `else` block:

```swift
var username: String? = nil

if let unwrappedName = username {
  print("We got a user: \(unwrappedName)")
} else {
  print("The optional was empty.")
}
```

Note: an optional integer set to `nil` is not the same as an non-optional integer holding 0.

```swift
func square(number: Int) -> Int {
  number * number
}

var number: Int? = nil
print(square(number: number))
```

Swift will refuse to build that code because the optional integer needs to be unwrapped - we cannot use an optional value where a non-optional is needed. To use the optional we must first *unwrap* it:

```swift
if let unwrappedNumber = number {
  print(square(number: unwrappedNumber))
}
```

When unwrapping optionals, it is very common to unwrap them into a constant of the same name. This is perfectly allowable in Swift, and means we do not need to keep naming constants `unwrappedNumber` or similar. Using this approach, we could rewrite as:

```swift
if let number = number {
  print(square(number: number))
}
```

## Unwrap optionals with guard

Besides using `if let` to unwrap optionals, another way is to use `guard let`:

```swift
func printSquare(of number: Int?) {
  guard let number = number else{
    print("Missing input")
    return
  }
  
  print("\(number) x \(number) is \(number * number)")
}
```

Just like `if let`, the `guard let` combo checks whether there is a value inside an optionals, and if there is will retrieve the value and place it into a constant of our choosing. However, the way it does so flips things around:

```swift
var myVar: Int? = 3

if let unwrapped = myVar {
  print("Run if myVar has a value inside")
}

guard let unwrapped = myVar else {
  print("Run if myVar doesn't have a value inside")
}
```

What `guard` provides is the ability to check whether our program state is what we expect, and if it is not to bail out - to exit from the current function. This is called *early return*: we check that all a function's inputs are valid right as the function starts, and if any are not valid we get to run some code then exit straight away.

Now we can rewrite the `printSquare()` function from previous section:

``` swift
func printSquare(of number: Int?) {
  guard let number = number else {
    print("Missing input")
    
    // We must exist the function here
    return
  }
  
  // number is still available outside of guard
  print("\(number) x \(number) is \(number * number)")
}
```

To demonstrate the difference between `if let` and `guard let`, here is a function that return an optional number:

```swift
func getMeaningOfLife() -> Int? {
  14
}

// if let
func printMeaningOfLife() {
  if let name = getMeaningOfLife() {
    print(name)
  }
}

// guard let
func printMeaningOfLife() {
  guard let name = getMeaningOfLife() else {
    return
  }
  
  print(name)
}
```

- `guard let` lets us focus on the "happy path" - the behavior of our function when everything has gone to plan.
- `guard` requires that we exit the current scope when it is used, which in this case means we must return from the function if it fails. THIS IS NOT OPTIONAL: Swift will NOT compile our code without the `return`.
- `guard let` must exist in the code block that can exit

## Unwrap optionals with nil coalescing

A third way to unwrap optionals is called the *nil coalescing operator*, and it lets us wrap an optional and provide a default value if the optional was empty.

```swift
let captains = [
  "Enterprice": "Picard",
  "Voyager": "JaneWay",
  "Defiant": "Sisko"
]

// non-existent key...
let new = captains["Serenity"]
```

This means the `new` constant will be an optional string to set to `nil`.

With the nil coalescing operator, written `??`, we can provide a default alue for any optionals:

```swift
let new = captains["Serenity"] ?? "N/A"
```

This will read the value from the `captains` dictionary and attempt to unwrap it. If the optional has a value inside it will be sent back and stored in `new`, but if it doesn't then `"N/A"` will be used instead. This means no matter what the optional contains - a value or `nil` - the ending result is that `new` will be a real string, not an optional one.

Recall that we can specify a default value when reading from dictionaries:

```swift
let new = captains["Serenity", default: "N/A"]
```

This produces exactly the same result. However, the nil coalescing operator does not only work with dictionaries, but also works with any optionals:

```swift
let tvShows = ["Archer", "Babylon 5", "Ted Lasso"]
let favorite = tvShows.randomElement() ?? "None"
```

We can also apply on optional property in a struct:

```swift
struct Book {
  let title: String
  let author: String?
}

let book = Book(title: "Beowulf", author: nil)
let author = book.author ?? "Anonymous"
print(author)
```

It is also useful if we create an integer from a string, where we actually get back an optional `Int?` because the conversion might be failed:

```swift
let input = ""
let number = Int(input) ?? 0
print(number)
```

We can also chain nil coalescing if we want to:

```swift
let savedData = first() ?? second() ?? ""
```

This will attempt to run `first()`, and if that returns nil, attempt to run `second()`, and if that returns nil, it will use an empty string.

## Handle multiple optionals using optional chaining

*Optional chaining* is a simplified syntax for reading optionals inside optionals.

```swift
let names = ["Arya", "Bran", "Robb", "Sansa"]


//.                               |optional chaining
let chosen = names.randomElement()?.uppercased() ?? "No one"
print("Next in line: \(chosen)")
```

Optional chaining allows us to say "if the optional has a value inside, unwrap it then..." and we can add more code. In this case, we say "if we manage to get a random element from the array, then uppercase it." NOTE: `randomElement()` returns an optional because the array may be empty.

Optional chaining silently does nothing if the optinal was empty - it will just send back the same optional we had before, still empty.

For example, suppose we want to place books in alphabetical order based on their author names:

- We have an optional instance of a `Book` struct - we may have a book to sort, or we may not.
- The book may have an author, or may be anonymous.
- If it does have an author string present, it may be an empty string or have text, so we cannot always rely on the first letter being there.
- If the first letter is there, make sure it is uppercase so that authors with lowercase names are sorted correctly.

The code would look like:

```swift
struct Book {
  let title: String
  let author: String?
}

var book: Book? = nil
let author = book?.author?.first?.uppercased() ?? "A"
print(author)
```

This reads "If we have a book, and the book has an author, and the author has a first letter, then uppercase it and send it back, otherwise send back A."

Swift's optional chaining let us dig through several layers of optionals in a single line of code, and if any one of those layers is nil then the whole line becomes nil. For a simple example,

```swift
let names = ["Vincent": "van Gogh", "Pablo": "Picasso", "Claude": "Monet"]

let surnameLetter = names["Vincent"]?.first?.uppercased() ?? "?"
```

Here we use optional chaining with the dictionary value because `names["Vincent"]` may not exist, and when reading the first character from the surname, because it is possible the string could be empty.

## Handle function failure with optionals

When we call a function that might throw errors, we either call it using `try` and handle errors appropriately, or if we are certain the function will not fail we use `try!` and accept that if we are wrong, our code will crash.

However, there is another approach: if all we care about is whether the function succeeded or failed, we can use an *optional* try to have the function return an optional value.

If the function runs without throwing an errors then the optional will contain the return value, but if any error is thrown, the function will return nil.

```swift
enum UserError: Error {
  case badID, networkFailed
}

func getUser(id: Int) throws -> String {
  throw UserError.networkFailed
}

if let user = try? getUser(id: 23) {
  print("User: \(user)")
}
```

The `getUser()` function will always throw a `networkFailed` error, which is fine for our testing purposes, but we do not actually care *what error* was thrown - all we care about is whether the call sent back a user or not.

This is where `try?` helps: it makes `getUser()` return an optional string, which will be nil if any errors are thrown. If we want to know exactly what error happened then this approach will NOT be useful.

If we want, we can combine `try?` with nil coalescing, which means "attempt to get the return value from this function, but if it fails use this default value instead" NOTE: we need to add some parentheses before nil coalescing so that Swift understands exactly what we mean. For example:

```swift
let user = (try? getUser(id: 30)) ?? "Anonymous"
print(user)
```



We can run throwing functions using `do`, `try`, and `catch` in Swift, but an alternative is to use `try?` to convert a throwing function call into an optional. If the function succeeds, its return value will be an optional containing whatever we would normally have recevied back, and if it fails the return value will be an optional set to nil.

```swift
do {
  let result = try runRiskyFunction()
  print(result)
} catch {
  // it failed?
}

// rewrite as optional try
if let result = try? runRiskyFunction() {
  print(result)
}
```

If we want to run a function and care only that it succeeds or fails - you do not need to distinguish between the various reasons why it may fail - then using optional try is a great fit.







