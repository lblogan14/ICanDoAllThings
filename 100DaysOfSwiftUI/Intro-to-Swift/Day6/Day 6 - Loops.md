# Day 6 - Loops

## Using a for loop to repeat work

```swift
let platforms = ["iOS", "macOS", "tvOS", "watchOS"]

for os in platforms {
  // loop body
  print("Swift works great on \(os).")
}

// loop vairable can be changed
for name in platforms {
  print("Swift works great on \(name).")
}
// or even
for rubberChicken in platforms {
    print("Swift works great on \(rubberChicken).")
}
```

Rather than looping over an array (or set, or dictionary), we can also loop over a fixed range of numbers:

```swift
for i in 1...12 {
  print("5 x \(i) is \(5 * i)")
}
```

The `1...12` part is a *range*, and means "all integer numbers between 1 and 12, as well as 1 and 12 themselves." *Ranges are their own unique data type in Swift*.

We can also have *nested loops*:

```swift
for i in 1...12 {
  print("The \(i) items table:")
  
  for j in 1...12 {
    print("  \(j) x \(i) is \(j * i)")
  }
  
  print()
}
```

`x...y` creates a range that starts with `x` and counts up to and including `y`. Swift has a similar-but-different type of range that counts up to but *excluding* the final number: `..<`

```swift
for i in 1...5 {
  print("Counting from 1 through 5: \(i)")
}
print()

for i in 1..<5 {
  print("Counting 1 up to 5: \(i)")
}
```

`..<` is really helpful for working with arrays, where we count from 0 and count up to but excluding the number of items in the array.

If we do not use the loop variable in the loop, we replace it with an underscore,

```swift
var lyric = "Haters gonna"

for _ in 1...5 {
  lyric += " hate"
}
print(lyric)
```

With ranges, we can use them in arrays:

```swift
// read individual item
print(platforms[0])

// read a range of values
print(platforms[0...2])
// fail when out of index
print(platforms[1...3]) // since we do not have the 4th item

// read 1 to the end of array
print(platforms[1...])
```

## Using a while loop to repeat work

```swift
var countdown = 10

while countdown > 0 {
  print("\(countdown)...")
  countdown -= 1
}
print("Blast off!")
```

`while` loops are useful when we do not know how many times the loop will go around.

The `random(in: )` method in `Int` and `Double` will send back a random `Int` or `Double` given a range of numbers. For example,

```swift
// a random integer between 1 and 1000
let id = Int.random(in: 1...1000)

// a random decimal between 0 and 1
let amount = Double.random(in: 0...1)
```

We can use this with the `while` loop:

```swift
var roll = 0

while roll != 20 {
  // roll a new dice
  roll = Int.random(in: 1...20)
  print("I rolled a \(roll)")
}
print("Critical hit!")
```

## Skipping loop items with break and continue

Swift gives two ways to skip one or more items in a loop:

- `continue` skips the current loop iteration
- `break` skips all remaining iterations

As an example of `continue`:

```swift
let filenames = ["me.jpg", "work.txt", "sophie.jpg", "logo.psd"]

for filename in filenames {
  if filename.hasSuffix(".jpg") == false {
    continue
  }
  print("Found picture: \(filename)")
}
```

The loop iterates each filename string and checks to make sure it has the suffix ".jpg". The `continue` is used with all the filenames failing that test, so that the rest of the loop body is skipped.

As an example of `break`:

```swift
let number1 = 4
let number2 = 14
var multiples = [Int]()

for i in 1...100_000 {
  if i.isMultiple(of: number1) && i.isMultiple(of: number2) {
    multiples.append(i)
    
    if multiples.count == 10 {
      break
    }
  }
}
print(multiples)
```

The loop counts from 1 through 100,000. If `i` is a multiple of both `number1` and `number2`, append it to the integer array. Once we hit 10 multiples, call `break` to exit the loop.



### labeled statements

Swift's labeled statements allow us to name certain parts of our code, and it is most commonly used for breaking out of nested loops.

For example,

```swift
let options = ["up", "down", "left", "right"]
let secretCombination = ["up", "up", "right"]
```

To find the `secretCombination`, we need to write three loops nested inside each other:

```swift
for option1 in options {
  for option2 in options {
    for option3 in options {
      print("In loop")
      let attempt = [option1, option2, option3]
      
        if attempt == secretCombination {
            print("The combination is \(attempt)!")
        }
    }
  }
}
```

but this code still runs even if we find the combination. This is where labeled statements come in:

```swift
outerLoop: for option1 in options {
  for option2 in options {
    for option3 in options {
      print("In loop")
      let attempt2 = [option1, option2, option3]
      
      if attempt2 == secretCombination {
        print("The combination is \(attempt2)")
        break outerLoop
      }
    }
  }
}
```

With the labeled `outerLoop`, those three loops stop running as soon as the combination is found.



## Summary

- `if`, `else`, `else if` statements
- `&&` - "and"; `||` - "or"
- `switch` statement must be exhaustive, which may mean adding a `default` case
- If one of our `switch` cases uses `fallthrough`, it means Swift will execute the following case afterwards.
- Ternary conditional operator format: WTF: What, True, False.
- `for` loop, `while` loop with `continue` and `break` statements