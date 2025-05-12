# Day 9 - Closures

**Closures** are liike anonymous functions - functions we can create and assign directly to a variable, pass into other functions to customize how they work.

## Create and use closures

We used to call functions, pass in values, and return data, but we can also assign them to variables, pass functions to functions, and even return functions from functions. For example:

```swift
func greetUser() {
  print("Hi there!")
}

greetUser()

var greetCopy = greetUser
greetCopy()
```

This creates a *copy* of the `greetUser()` function and calls the `greetCopy()`. So when we copy a function, we do not write the parentheses after it. If we put the parentheses there, we are calling the function and assigning its returned value back.

If we want to *skip* creating a separate function, and just assign the functionality directly to a constant or varible,

```swift
let sayHello = {
  print("Hi there!")
}

sayHello()
```

This is an example of *closure expression* in Swift.

If we want the closure to accept parameters, they need to be written in a speical way. We need to put everything *inside* the curly braces:

```swift
let sayHello = {
  (name: String) -> String in
  "Hi \(name)!"
}
```

The extra keyword `in` comes directly after the parameters and return type of the closure. With a regular function, the parameters and return types would cme *outside* the curly braces, but we cannot do that with closures since everything needs to be inside the curly braces. Therefore, `in` is used to mark the end of the parameters and return types - everything after that is the body of the closure itself.

To figure out why **closures** are so useful, we will first understand the *function types*. As integers have the type `Int` and decimals have the type `Double`, etc, funtions have types too. If we want to write `greetCopy` as a type annotation, we would write:

```swift
var greetCopy: () -> Void = greetUser
```

- The empty parentheses marks a function that takes *no parameters*.
- The arrow `->` means to declare the return type for the function.
- `Void` means "nothing" - this function returns nothing. Sometimes may written as `()`, but usually avoided because it may be confused with the empty parameter list.

Every function's type depends on the data it receives and sends back. For example:

```swift
func getUserData(for Id: Int) -> String {
  if id == 1992 {
    return "Kyrie Irving"
  } else {
    return "Anonymous"
  }
}

let data: (Int) -> String = getUserData
let user = data(1992)
print(user)
```

After we take a copy of the `getUserData()` function, the type of function does not include the `for` external parameter name, so when the copied function `data()` is called, we use `data(1992)` rather than `data(for: 1992)`.

Hence, external parameter names only matter when we are calling a function directly, not when we create a closure or when we take a copy of the function first. For example, when we use `sorted()` with an array,

```swift
let teams = ["Warriors", "Bulls", "Caveliers", "Mavericks"]
let sortedTeams = teams.sorted()
print(sortedTeams)
```

What if we always want one team come first because that is our favorite team? `sorted()` allows us to pass in a custom sorting function to control this. This function must accept two strings, and return true if the first string should be sorted before the second, or false if the first string should be sorted after the second.

For example, if Warriors is our favorite team, the function would look like

```swift
func favoriteFirstSorted(name1: String, name2: String) -> Bool {
  if name1 == "Warriors" {
    return true
  } else if name2 == "Warriors"{
    return false
  }
  
  return name1 < name2
}
```

If the first name is Warriors, return `true` so that `name1` is sorted before `name2`. On the other hand, if `name2` is Warriors, return `false` so that `name1` is sorted after `name2`. If neither name is Warriors, just use `<` to do a normal alphabetical sort. Now we can pass this function to `sorted()`:

```swift
let favoriteFirstTeams = teams.sorted(by: favoriteFirstSorted)
print(favoriteFirstTeams)
```

To recap, we covered two things. First, we can create closures as anonymous functions, storing them inside constants and variables:

```swift
let sayHello = {
  print("HI there!")
}

sayHello()
```

Second, we are able to pass functions into other functions:

```swift
let favoriteFirstTeams = teams.sorted(by: favoriteFirstSorted)
```

The power of closures is that we can put these two together: `sorted()` wants a function that will accept two strings and return a Boolean, and it does not care if that function was created formally using `func` or whether it is provided using a closure. So we would write the following without creating the custom actual function:

```swift
let favoriteFirstTeams = teams.sorted(
	by: {
    (name1: String, name2: String) -> Bool in
    if name1 == "Warriors" {
      return true
    } else if name2 == "Warriors" {
      return false
    }
    
    return name1 < name2
  }
)
```

- We are calling the `sorted()` function as before
- Rather than passing in a function, we pass a closure - everyhing after `by: `
- Directly inside the closure, we list the two parameters `sorted()` will pass us, which are two strings. We also say that our closure will return a Boolean, then ark the start of the closure's code by using `in`
- Everything else is just normal function

### Return values from closure

A closure that accepts one parameter and returns nothing:

```swift
let payment = {
  (user: String) in
  print("Paying \(user)...")
}
```

A closure that accepts one parameter and returns a Boolean:

```swift
let payment = {
  (user: String) -> Bool in
  print("Paying \(user)...")
  return true
}
```

A closure that **returns a value without accepting any parameters:

```swift
let payment = {
  () -> Bool in
  print("Paying an anonymous person...")
  return true
}
```

This works just the same as a standard function:

```swift
func pay() -> Bool {
  print("Paying an anonymou person...")
  return true
}

let payment = pay()
```

## Use trailing closures and shorthand syntax

Swift has a few tricks to reduce the amount of syntax that comes with closures. From the previous section, we have 

```swift
let favoriteFirstTeams = teams.sorted(
	by: {
    (name1: String, name2: String) -> Bool in
    if name1 == "Warriors" {
      return true
    } else if name2 == "Warriors" {
      return false
    }
    
    return name1 < name2
  }
)
```

Remind that `sorted()` can accept any kind of function to do custom sorting, with one rule: that function must accept two items from the array in question (two strings), and return a Boolean set to true if the first string should be sorted before the second.

The function **must** behave like this - if it returns nothing or only accepts one string, then Swift would refuse to build our code.

Now in this code, the function we provide to `sorted()` must probive two strings and return a Boolean. If we do not want to repeat and specify the types of our two input `String` parameters and a return `Boolean` type, we can rewrite our clousre as the following:

```swift
let favoriteFirstTeams = teams.sorted {
  name1, name2 in
  if name1 == "Warriors" {
    return true
  } else if name2 == "Warriors" {
    return false
  }
  
  return name1 < name2
}
```

This is called *trailing closure syntax* in Swift. Rather than passing the closure in as a parameter, we just go ahead and start the closure directly - and in doing so remove `(by:...) ` part. This is why we need the parameter list and `in` come *inside* the closure.

In addition, Swift can automatically provide parameter names for us, using *shorthand syntax*. With this syntax, we do not even write `name1, name2 in` anymore, and instead we rely on *specially named values* that Swift provides for us: `$0` and `$1`, for the first and second strings, respectively. For example,

```swift
let favoriteFirstTeams = teams.sorted {
  if $0 == "Warriors" {
    return true
  } else if $1 == "Warriors" {
    return false
  }
  
  return $0 < $1
}
```

This makes the code less clear and less recommended because we are using each value more than once, but if our `sorted()` call was simpler - e.g., if we just want to do a reverse sort, then we could write:

```swift
let reverseTeams = teams.sorted {
  return $0 > $1
}
```

Therefore, `in` is used to mark the end of the parameters and return type - everything after that is the body of the closure itself. In the example above we have flipped the comparison from `<` to `>` so we get a reverse sort, but now that we are down to single line of code, we can remove the `return` and get it down to:

```swift
let reverseTeams = teams.sorted {$0 > $1}
```

When we consider to use shorthand syntax:

- The closure code is long.
- `$0` and friends are used more than once each.
- We get three or more parameters (e.g., `$2`, `$3`, etc)

We can take another example using closure. The `filter()` function lets us run some code on every item in the array, and will send back a new array containing every item that returns true for the function. So, we could find all teams whose name begins with W:

```swift
let wOnly = teams.filter { $0.hasPrefix("W") }
print(wOnly)
```

The `map()` function lets us transform every item in the array using some code of our choosing, and sends back a new array of all the transformed items:

```swift
let uppercaseTeams = teams.map { $0.uppercased() }
print(uppercaseTeams)
```

Why **closures** are common in SwiftUI:

- When we create a list of data on the screen, SwiftUI will ask us to provide a function that accepts one item from the list and converts it something it can display on-screen.
- When we create a button, SwiftUI will ask us to provide one funtion to execute when the button is pressed, and another to generate the contents of the button - a picture, or some text, and so on.
- Even just putting stacking pieces of text vertically is done using a closure.

### Trailing closure syntax example

```swift
func animate(duration: Double, animations: () -> Void) {
  print("Starting a \(duration) second animation...")
  animations()
}
```

We can call that function without a trailing closure like this:

```swift
animate(duration: 3, animations {
  print("Fade out the image.")
})
```

Trailing closures allow us to clean `})` up, while also removing the `animations` parameter label:

```swift
animate(duration: 3) {
  print("Fade out the image.")
}
```

Trailing closures work best when their meaning is directly attached to the name of the function. We can see what the closure is doing because the function is called `animate()`.

## Accept functions as parameters

Previously we have

```swift
func greetUser() {
  print("Hi there!")
}

greetUser()

var greetCopy: () -> Void = greetUser
greetCopy()
```

The type annotation is exactly what we use when specying functions as parameters. We tell Swift what parameters the function accepts, as well as its return type.

For example, the following function generates an array of integers by repeating a function a certain number of times:

```swift
func makeArray(size: Int, using generator: () -> Int) -> [Int] {
  var numbers = [Int]()
	
  for _ in 0..<size {
    let newNumber = generator()
    numbers.append(newNumber)
  }
  
  return numbers
}
```

- The function is called `makeArray()`, which takes two parameters, the first one is the number of integers we want, and also returns an array of integers.
- The second parameter is a function, which accepts no parameters itself, but will return one integer every time it is called.
- Inside `maekArray()` we create a new empty array of integers, then loop as many times as requested.
- Each time the loop goes around we call the `generator` function that was passed in as a parameter. This will return one new integer, so we put that into the `numbers` array.

We can now make arbitrary-sized integer arrays, passing in a function that should be used to generate each number:

```swift
let rolls = makeArray(size: 50) {
  Int.random(in: 1...20)
}
print(rolls)
```

The same functionality works with dedicated funtions too, so we could write:

```swift
func generateNumber() -> Int {
  Int.random(in: 1...20)
}

let newRolls = makeArray(size:50, using: generateNumber)
print(newRolls)
```

This will call `generateNumber()` 50 times to fill the array.

We can make our function accept *multiple function parameters* if we want, in which case we can specify multiiple trailing closures. To demonstrate this, we create a function that accepts three function parameters, each of which accept no parameters and return nothing:

```swift
func doImportantWork(first: () -> Void, second: () -> Void, third: () -> Void) {
  print("About to start first work")
  first()
  print("About to start second work")
  second()
  print("About to start third work")
  third()
  print("Done!")
}
```

When it comes to calling that function, the first trailing closure is identical to what we have used already, but the second and third are formatted differently:

```swift
doImportantWork {
  print("This is the first work")
} second: {
  print("This is the second work")
} third: {
	print("This is the third work")
}
```

Having three trailing closures is not as common as we expect.