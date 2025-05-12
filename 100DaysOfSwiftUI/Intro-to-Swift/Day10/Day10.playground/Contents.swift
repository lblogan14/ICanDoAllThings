import Cocoa

var greeting = "Hello, playground"

// struct
struct Album {
  let title: String
  let artist: String
  let year: Int
  
  func printSummary() {
    print("\(title) \(year) by \(artist)")
  }
}

let clouds = Album(title: "Clouds", artist: "NF", year: 2021)
let xposed = Album(title: "Xposed", artist: "G.E.M.", year: 2012)

print(clouds.title)
print(xposed.artist)

clouds.printSummary()
xposed.printSummary()

/*
struct Employee {
  let name: String
  var vacationRemaining: Int
  
  func takeVacation(days: Int) {
    if vacationRemaining > days {
      vacationRemaining -= days
      print("I'm going on vacation!")
      print("Days remaining: \(vacationRemaining)")
    } else {
      print("Oops! There are not enough days remaining.")
    }
  }
}
*/

struct Employee2 {
  let name: String
  var vacationRemaining: Int
  
  mutating func takeVacation(days: Int) {
    if vacationRemaining > days {
      vacationRemaining -= days
      print("I'm going on vacation!")
      print("Days remaining: \(vacationRemaining)")
    } else {
      print("Oops! There are not enough days remaining.")
    }
  }
}

var archer = Employee2(name: "Sterling Archer", vacationRemaining: 14)
archer.takeVacation(days: 5)
print(archer.vacationRemaining)

var archer1 = Employee2(name: "Sterling Archer", vacationRemaining: 14)
var archer2 = Employee2.init(name: "Sterling Archer", vacationRemaining: 14)


struct Employee3 {
    let name: String
    var vacationRemaining: Int
}

var archer3 = Employee3(name: "Sterling Archer", vacationRemaining: 14)
archer3.vacationRemaining -= 5
print(archer3.vacationRemaining)
archer3.vacationRemaining -= 3
print(archer3.vacationRemaining)


struct Employee4 {
  let name: String
  var vacationAllocated = 14
  var vacationTaken = 0
  
  var vacationRemaining: Int {
    vacationAllocated - vacationTaken
  }
}


var archer4 = Employee4(name: "Sterling Archer", vacationAllocated: 14)
archer4.vacationTaken += 4
print(archer4.vacationRemaining)
archer4.vacationTaken += 4
print(archer4.vacationRemaining)


struct Employee5 {
  let name: String
  var vacationAllocated = 14
  var vacationTaken = 0
  
  var vacationRemaining: Int {
    get {
      vacationAllocated - vacationTaken
    }
    
    set {
      vacationAllocated = vacationTaken + newValue
    }
  }
}

var archer5 = Employee5(name: "Sterling Archer", vacationAllocated: 14)
archer5.vacationTaken += 4
archer5.vacationRemaining = 5
print(archer5.vacationAllocated)


// property observers
struct Game {
  var score = 0
}

var game = Game()
game.score += 10
print("Score is now \(game.score)")
game.score -= 3
print("Score is now \(game.score)")
game.score += 1


struct Game2 {
  var score = 0 {
    didSet {
      print("Score is not \(score)")
    }
  }
}

var game2 = Game2()
game2.score += 10
game2.score -= 3
game2.score += 1


struct App {
  var contacts = [String]() {
    willSet {
      print("Current value is: \(contacts)")
      print("New value will be: \(newValue)")
    }
    
    didSet {
      print("There are now \(contacts.count) contacts.")
      print("Old value was \(oldValue)")
    }
  }
}

var app = App()
app.contacts.append("Steph C")
app.contacts.append("Kyrie I")
app.contacts.append("Derrick R")


// initializers
struct Player {
  let name: String
  let number: Int
  
  init(name: String) {
    self.name = name
    number = Int.random(in: 1...99)
  }
}

let player = Player(name: "Steph C")
print(player.number)


struct Player2 {
  var name: String
  var yearsActive = 0
}
let steph = Player2(name: "Steph Curry")
let kyrie = Player2(name: "Kyrie Ivring", yearsActive: 13)


struct Player3 {
  var name: String
  var yearsActive = 0
  
  init() {
    self.name = "Anonymous"
    print("Creating an anonymous employee...")
  }
}
//let steph3 = Player3(name: "Steph Curry")

struct Player4 {
  var name: String
  var yearsActive = 0
}

extension Player4 {
  init() {
    self.name = "Anonymous"
    print("Creating an anonymous employee...")
  }
}

// Creating a named employee now works
let derrick = Player4(name: "Derrick Rose")

// as does creating an anonymous employee
let anon = Player4()
