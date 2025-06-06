import Cocoa

var greeting = "Hello, playground"

let score = 85

if score > 80 {
    print("Great job!")
}


let speed = 88
let percentage = 85
let age = 18

if speed >= 88 {
  print("Where we're going we don't need roads.")
}

if percentage < 85 {
  print("Sorry, you failed the test.")
}

if age >= 21 {
  print("You're eligible to drink.")
}

let ourName = "Dave Lister"
let friendName = "Arnold Rimmer"

if ourName < friendName {
  print("It's \(ourName) vs \(friendName)")
}

if ourName > friendName {
  print("It's \(friendName) vs \(ourName)")
}


// Make an array of 3 numbers
var numbers = [1, 2, 3]

// Add a 4th
numbers.append(4)

// If we have more than 3 items
if numbers.count > 3 {
  // Remove the oldest number
  numbers.remove(at: 0)
}

print(numbers)


let country = "Canada"

if country == "Australia" {
  print("G'day!")
}

let name = "Steph Curry"

if name != "Anonymous" {
  print("Welcom, \(name)")
}

var username = "sc30"

// If `username` contains an empty string
if username == "" {
  // Assign "Anonymous" to it
  username = "Anonymous"
}

print("Welcome, \(username)!")

if username.count == 0 {
  username = "Anonymous"
}

if username.isEmpty == true {
  username = "Anonymous"
}

if username.isEmpty {
  username = "Anonymous"
}

// Multiple conditions

let age2 = 16

if age2 >= 21 {
  print("You can drink beer")
} else {
  print("Sorry, you're too yound")
}


let a = false
let b = true

if a {
  print("Code to run if `a` is true")
} else if b {
  print("Code to run if `a` is false but `b` is true")
} else {
  print("Code to run if both `a` and `b` are false")
}

let temp = 25

if temp > 20 {
  if temp < 30 {
    print("It's a nice day.")
  }
}

if temp > 20 && temp < 30 {
  print("It's a nice day.")
}


let userAge = 14
let hasParentalConsent = true

if userAge >= 18 || hasParentalConsent == true {
  print("You can buy the game.")
}
// OR more convenient
if userAge >= 18 || hasParentalConsent {
  print("You can buy the game.")
}


enum TransportOption {
  case airplane, helicopter, bicycle, car, scooter
}

let transport = TransportOption.airplane

if transport == .airplane || transport == .helicopter {
  print("Let's fly!")
} else if transport == .bicycle {
  print("I hope there's a bike path...")
} else if transport == .car {
  print("Time to get stuck in traffic.")
} else {
  print("I'm going to ride a scooter now.")
}


// switch statement
enum Weather {
  case sun, rain, wind, snow, unknown
}

let forecast = Weather.sun

if forecast == .sun {
  print("It should be a nice day.")
} else if forecast == .rain {
  print("Pack an umbrella.")
} else if forecast == .wind {
  print("Wear something warm.")
} else if forecast == .snow {
  print("School is cancelled.")
} else {
  print("Our forecast generator is broken!")
}

switch forecast {
  case .sun:
      print("It should be a nice day.")
     case .rain:
      print("Pack an umbrella.")
  case .wind:
      print("Wear something warm.")
  case .snow:
      print("School is cancelled.")
  case .unknown:
      print("Our forecast generator is broken!")
}


let place = "Metropolis"

switch place {
  case "Gotham":
      print("You're Batman!")
  case "Mega-City One":
      print("You're Judge Dredd!")
  case "Wakanda":
      print("You're Black Panther!")
  default:
      print("Who are you?")
}


let day = 5

print("My true love gave to me…")

switch day {
case 5:
    print("5 golden rings")
case 4:
    print("4 calling birds")
case 3:
    print("3 French hens")
case 2:
    print("2 turtle doves")
default:
    print("A partridge in a pear tree")
}

print("My true love gave to me…")

switch day {
    case 5:
    print("5 golden rings")
    fallthrough
    case 4:
    print("4 calling birds")
    fallthrough
    case 3:
    print("3 French hens")
    fallthrough
    case 2:
    print("2 turtle doves")
    fallthrough
    default:
    print("A partridge in a pear tree")
}


// ternary operator
let age3 = 18
let canDrink = age3 >= 21 ? "Yes" : "No"

let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")

let names = ["Jayne", "Kaylee", "Mal"]
let crewCount = names.isEmpty ? "No one" : "\(names.count) people"
print(crewCount)

enum Theme {
  case light, dark
}
let theme = Theme.dark

let background = theme == .dark ? "black" : "white"
print(background)
