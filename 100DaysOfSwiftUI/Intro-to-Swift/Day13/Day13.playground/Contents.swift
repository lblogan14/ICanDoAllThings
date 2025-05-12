import Cocoa

var greeting = "Hello, playground"


// protocols
protocol Vehicle {
  func estimateTime(for distance: Int) -> Int
  func travel(distance: Int)
}

struct Car: Vehicle {
  func estimateTime(for distance: Int) -> Int {
    distance / 50
  }
  
  func travel(distance: Int) {
    print("I'm driving \(distance) km.")
  }
  
  func openSunroof() {
    print("It's a nice day!")
  }
}

func commute(distance: Int, using vehicle: Vehicle) {
  if vehicle.estimateTime(for: distance) > 100 {
    print("That's too slow! I'll try a different vehicle.")
  } else {
    vehicle.travel(distance: distance)
  }
}

let car = Car()
commute(distance: 100, using: car)

struct Bicycle: Vehicle {
  func estimateTime(for distance: Int) -> Int {
    distance / 10
  }
  
  func travel(distance: Int) {
    print("I'm cycling \(distance) km.")
  }
}

let bike = Bicycle()
commute(distance: 50, using: bike)


protocol Vehicle2 {
  var name: String { get }
  var currentPassengers: Int { get set }
  func estimateTime(for distance: Int) -> Int
  func travel(distance: Int)
}

struct Car2: Vehicle2 {
  let name = "Car"
  var currentPassengers = 1
  
  func estimateTime(for distance: Int) -> Int {
    distance / 50
  }
  
  func travel(distance: Int) {
    print("I'm driving \(distance) km.")
  }
  
  func openSunroof() {
    print("It's a nice day!")
  }
}


struct Bicycle2: Vehicle2 {
  let name = "Bicycle"
  var currentPassengers = 1
  
  func estimateTime(for distance: Int) -> Int {
    distance / 10
  }
  
  func travel(distance: Int) {
    print("I'm cycling \(distance) km.")
  }
}

func getTravelEstimates(using vehicles: [Vehicle2], distance: Int) {
  for vehicle in vehicles {
    let estimate = vehicle.estimateTime(for: distance)
    print("\(vehicle.name): \(estimate) hours to travel \(distance) km.")
  }
}

let car2 = Car2()
let bike2 = Bicycle2()
getTravelEstimates(using: [car2, bike2], distance: 150)


// opaque return types
func getRandomNumber() -> some Equatable {
  Int.random(in: 1...6)
}

func getRandomBool() -> some Equatable {
  Bool.random()
}

// no error
print(getRandomNumber() == getRandomNumber())


// extensions
var quote = "   The truth is rarely pure and never simple   "

let trimmed = quote.trimmingCharacters(in: .whitespacesAndNewlines)

extension String {
  func trimmed() -> String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

let trimmed2 = quote.trimmed()

func trim(_ string: String) -> String {
  string.trimmingCharacters(in: .whitespacesAndNewlines)
}

let trimmed_f = trim(quote)


extension String {
  func trimmed2() -> String {
    self.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  mutating func trim() {
    self = self.trimmed2()
  }
}

var quote2 = "   The truth is rarely pure and never simple   "
// trim in place now
quote2.trim()
print(quote)



extension String {
    var lines: [String] {
      self.components(separatedBy: .newlines)
    }
}

let lyrics = """
But I keep cruising
Can't stop, won't stop moving
It's like I got this music in my mind
Saying it's gonna be alright
"""

print(lyrics.lines.count)


struct Book {
  let title: String
  let pageCount: Int
  let readingHours: Int
}

extension Book {
  init(title: String, pageCount: Int) {
    self.title = title
    self.pageCount = pageCount
    self.readingHours = pageCount / 50
  }
}

let lotr = Book(title: "Lord of the Rings", pageCount: 1178, readingHours: 24)


// protocol extensions
let guests = ["Mario", "Luigi", "Peach"]

if guests.isEmpty == false {
  print("Guest count: \(guests.count)")
}
if !guests.isEmpty {
  print("Guest count: \(guests.count)")
}


extension Array {
  var isNotEmpty: Bool {
    isEmpty == false
  }
}

let guests2 = ["Mario", "Luigi", "Peach"]
if guests2.isNotEmpty {
  print("Guest count: \(guests2.count)")
}

extension Collection {
  var isNotEmpty: Bool {
    isEmpty == false
  }
}


protocol Person {
  var name: String { get }
  func sayHello()
}
extension Person {
  func sayHello() {
    print("Hi, I'm \(name)")
  }
}

struct Employee: Person {
  let name: String
}


let steph = Employee(name: "Steph Curry")
steph.sayHello()
