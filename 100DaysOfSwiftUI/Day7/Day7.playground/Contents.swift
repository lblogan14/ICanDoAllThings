import Cocoa

var greeting = "Hello, playground"

func showWelcome() {
    print("Welcome to my app!")
    print("By default This prints out a conversion")
    print("chart from centimeters to inches, but you")
    print("can also set a custom range if you want.")
}

func printTimesTables(number: Int) {
  for i in 1...12 {
    print("\(i) x \(number) is \(i * number)")
  }
}

// call our function
printTimesTables(number: 5)

func printTimesTables(number: Int, end: Int) {
  for i in 1...end {
    print("\(i) x \(number) is \(i * number)")
  }
}

// call our updated function
printTimesTables(number: 5, end: 20)

// not valid to call
//printTimesTables(end:20, number: 5)


func rollDice() -> Int {
  return Int.random(in: 1...6)
}

let result = rollDice()
print(result)

func areLettersIdentical(string1: String, string2: String) -> Bool {
  let first = string1.sorted()
  let second = string2.sorted()
  return first == second
}

func areLettersIdentical2(string1: String, string2: String) -> Bool {
  return string1.sorted() == string2.sorted()
}

func areLettersIdentical3(string1: String, string2: String) -> Bool {
  string1.sorted() == string2.sorted()
}

func pythagoras(a: Double, b: Double) -> Double {
  let input = a * a + b * b
  let root = sqrt(input)
  return root
}

let c = pythagoras(a: 3, b: 4)
print(c)

func pythagoras2(a: Double, b: Double) -> Double {
  sqrt(a * a + b * b)
}

func getUser() -> [String] {
  ["Steph", "Curry"]
}

let user = getUser()
print("Name: \(user[0]) \(user[1])")


func getUser2() -> [String: String] {
  [
    "firstName": "Steph",
    "lastName": "Curry"
  ]
}

let user2 = getUser2()
print("Name: \(user2["firstName", default: "Anonymous"]) \(user2["lastName", default: "Anonymous"])")


func getUser3() -> (firstName: String, lastName: String) {
  (firstName: "Steph", lastName: "Curry")
}

let user3 = getUser3()
print("Name: \(user3.firstName) \(user3.lastName)")

func getUser4() -> (firstName: String, lastName: String) {
  ("Steph", "Curry")
}


func getUser5() -> (String, String) {
  ("Steph", "Curry")
}

let user5 = getUser5()
print("Name: \(user5.0) \(user5.1)")


func getUser6() -> (firstName: String, lastName: String) {
    (firstName: "Steph", lastName: "Curry")
}

let user6 = getUser6()
let firstName = user6.firstName
let lastName = user6.lastName

let (firstName2, lastName2) = getUser6()
print("Name: \(firstName2) \(lastName2)")


let (firstName3, _) = getUser6()
print("Name: \(firstName3)")



func rollDice(sides: Int, count: Int) -> [Int] {
  // start with an empty array
  var rolls = [Int]()
  
  // roll as many dices as needed
  for _ in 1...count {
    // add each result to our array
    let roll = Int.random(in: 1...sides)
    rolls.append(roll)
  }
  
  // send back all the rools
  return rolls
}

let rolls = rollDice(sides: 6, count: 4)


func isUppercase(string: String) -> Bool {
  string == string.uppercased()
}
let string = "HELLO, WORLD"
//let result = isUppercase(string: string)


func isUppercase2(_ stirng: String) -> Bool {
  string == string.uppercased()
}

let string2 = "HELLO, WORLD"
let result2 = isUppercase2(string2)


func printTimesTables2(number: Int) {
  for i in 1...12 {
    print("\(i) x \(number) is \(i * number)")
  }
}

printTimesTables2(number: 5)


func printTimesTables3(for number: Int) {
  for i in 1...12 {
    print("\(i) x \(number) is \(i * number)")
  }
}

printTimesTables3(for: 5)
