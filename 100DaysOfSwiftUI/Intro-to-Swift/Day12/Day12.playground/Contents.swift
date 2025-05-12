import Cocoa

var greeting = "Hello, playground"


// parent class
class Employee {
  let hours: Int
  
  init(hours: Int) {
    self.hours = hours
  }
}

// children classes
class Developer: Employee {
  func work() {
    print("I'm writing code for \(hours) hours.")
  }
}

class Manager: Employee {
  func work() {
    print("I'm going to meetings for \(hours) hours.")
  }
}

let robert = Developer(hours: 8)
let joe = Manager(hours: 10)

robert.work()
joe.work()


// parent class
class Employee2 {
  let hours: Int
  
  func printSummary() {
    print("I work \(hours) hours a day.")
  }
  
  init(hours: Int) {
    self.hours = hours
  }
}

class Developer2: Employee2 {
  func work() {
    print("I'm writing code for \(hours) hours.")
  }
  
  override func printSummary() {
    print("I'm a developer who will sometimes work \(hours) hours a day, but other times spend hours arguing about whether code should be indented using tab or spaces.")
  }
}


let nova = Developer2(hours: 8)
nova.printSummary()


final class Manager2: Employee {
  func work() {
    print("I'm going to meetings for \(hours) hours.")
  }
}

// initializer
class Vehicle {
  let isElectric: Bool
  
  init(isElectric: Bool) {
    self.isElectric = isElectric
  }
}

class Car: Vehicle {
  let isConvertible: Bool
  
  init(isElectric: Bool, isConvertible: Bool) {
    self.isConvertible = isConvertible
    super.init(isElectric: isElectric)
  }
}

let teslaX = Car(isElectric: true, isConvertible: false)


// copy classes
class User {
  var username = "Anonymous"
}


var user1 = User()

// take a copy
var user2 = user1
user2.username = "Steph"

// check results
print(user1.username)
print(user2.username)


struct UserS {
  var username = "Anonymous"
}

var user1s = UserS()

// take a copy
var user2s = user1s
user2s.username = "Steph"

// check results
print(user1s.username)
print(user2s.username)


class User2 {
  var username = "Anonymous"
  
  func copy() -> User2 {
    let user = User2()
    user.username = username
    return user
  }
}


// deinitializer
class User3 {
  let id: Int
  
  init(id: Int) {
    self.id = id
    print("User \(id): I'm alive!")
  }
  
  deinit {
    print("User \(id): I'm dead!")
  }
}

for i in 1...3 {
  let user = User3(id: i)
  print("User \(user.id): I'm in control!")
}


var users = [User3]()

for i in 1...3 {
  let user = User3(id: i)
  print("User \(user.id): I'm in control!")
  users.append(user)
}

print("Loop is finished!")
users.removeAll()
print("Array is clear!")


// variable inside classes
class User4 {
  var name = "Steph"
}

let user = User4()
user.name = "Kyrie"
print(user.name)

class User5 {
  var name = "Steph"
}

var user5 = User5()
user5.name = "Kyrie"
print(user5.name)
user5 = User5()
print(user5.name)
user5 = User5()
print(user5)
