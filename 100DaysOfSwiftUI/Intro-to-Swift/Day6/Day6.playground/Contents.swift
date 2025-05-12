import Cocoa

var greeting = "Hello, playground"

// for loop
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

// range
for i in 1...12 {
  print("5 x \(i) is \(5 * i)")
}

// nested loop
for i in 1...12 {
  print("The \(i) items table:")
  
  for j in 1...12 {
    print("  \(j) x \(i) is \(j * i)")
  }
  
  print()
}

// read individual item
print(platforms[0])

// read a range of values
print(platforms[0...2])
// fail when out of index
print(platforms[1...3]) // since we do not have the 4th item

// read 1 to the end of array
print(platforms[1...])


// while loop
var countdown = 10

while countdown > 0 {
  print("\(countdown)...")
  countdown -= 1
}
print("Blast off!")

// a random integer between 1 and 1000
let id = Int.random(in: 1...1000)

// a random decimal between 0 and 1
let amount = Double.random(in: 0...1)

var roll = 0

while roll != 20 {
  // roll a new dice
  roll = Int.random(in: 1...20)
  print("I rolled a \(roll)")
}
print("Critical hit!")


// continue statement
let filenames = ["me.jpg", "work.txt", "sophie.jpg", "logo.psd"]

for filename in filenames {
  if filename.hasSuffix(".jpg") == false {
    continue
  }
  print("Found picture: \(filename)")
}

// break statement
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

// labeled statements
let options = ["up", "down", "left", "right"]
let secretCombination = ["up", "up", "right"]

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
