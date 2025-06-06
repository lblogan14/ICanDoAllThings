import Cocoa

// boolean
let filename = "basketball.jpg"
print(filename.hasSuffix(".jpg"))
let num = 120
print(num.isMultiple(of: 4))

let goodDogs = true
let startOver = false
let isMultiple = 120.isMultiple(of: 3)

var isAuthenticated = false
isAuthenticated = !isAuthenticated
print(isAuthenticated)
isAuthenticated = !isAuthenticated
print(isAuthenticated)

var gameOver = false
print(gameOver)
gameOver.toggle()
print(gameOver)

let firstPart = "Hello, "
let secondPart = "world!"
let greeting = firstPart + secondPart

let people = "Haters"
let action = "hate"
let lyric = people + " gonna " + action
print(lyric)

let luggageCode = "1" + "2" + "3" + "4" + "5"

// String interpolation
let name = "Steph"
let age = 30
let message = "Hello, my name is \(name) and I'm \(age) years old."
print(message)

let number = 11
// Uncomment to see the error
//let missionMessage = "Apollo " + number + " landed on the moon."
let missionMessage = "Apollo \(number) landed on the moon."

print("5 x 5 is \(5 * 5)")
