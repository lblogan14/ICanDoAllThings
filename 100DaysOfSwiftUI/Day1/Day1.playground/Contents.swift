import Cocoa

var greeting = "Hello, playground"

// Intialize a name string variable
var name = "Derrick Rose"
name = "Kyrie Irving"
name = "Steph Curry"

// Initialize a constant
let character = "Babeface"
// Uncomment to see the error
//character = "Artist on Court"

// Print out variables
var playerName = "Steph Curry"
print(playerName)
playerName = "Derrick Rose"
print(playerName)
playerName = "Kyrie Irving"
print(playerName)

// Create string constants
let actor = "Steph Curry"
let filename = "GSW.jpg"
let result = "⭐️ You win! ⭐️"
let quote = "Then he tapped a sign saying \"Believe\" and walked away."
let movie = """
A day in
the lieft of an
Apple engineer
"""
// String methods
print(actor.count)
let nameLength = actor.count
print(nameLength)
print(result.uppercased())
print(movie.hasPrefix("A day"))
print(filename.hasSuffix(".jpg"))


// Create integers
let score = 10
let reallyBig = 100000000
let reallyBigGood = 100_000_000
let reallyBigWeird = 1_00__00___00____00

// operations
let lowerScore = score - 2
let higherScore = score + 10
let doubledScore = score * 2
let squaredScore = score * score
let halvedScore = score / 2
print(score)

var counter = 10
counter = counter + 5
counter += 5
print(counter)
counter *= 2
print(counter)
counter -= 10
print(counter)
counter /= 2
print(counter)

// integer methods
let number = 120
print(number.isMultiple(of: 3))
print(120.isMultiple(of: 3))

// Create decimals
let decimal = 0.1 + 0.2
print(decimal)

let a = 1
let b = 2.0
// Uncomment to see the error
//let c = a + b
let c = a + Int(b)
let d = Double(a) + b

let double1 = 3.1
let double2 = 3131.3131
let double3 = 3.0
let int1 = 3

var name2 = "Nicolas Cage"
name2 = "John Travolta"
print(name2)
// Uncomment to see the error
//name2 = 57

var rating = 5.0
rating *= 2
