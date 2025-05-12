import Cocoa

var greeting = "Hello, playground"

func greetUser() {
  print("Hi there!")
}

greetUser()

var greetCopy = greetUser
greetCopy()

let sayHello = {
  print("Hi there!")
}

sayHello()

// closure
let sayHello2 = {
  (name: String) -> String in
  "Hi \(name)!"
}

var greetCopy2: () -> Void = greetUser

func getUserData(for id: Int) -> String {
  if id == 1992 {
    return "Kyrie Irving"
  } else {
    return "Anonymous"
  }
}

let data: (Int) -> String = getUserData
let user = data(1992)
print(user)

let teams = ["Warriors", "Bulls", "Caveliers", "Mavericks"]
let sortedTeams = teams.sorted()
print(sortedTeams)

func favoriteFirstSorted(name1: String, name2: String) -> Bool {
  if name1 == "Warriors" {
    return true
  } else if name2 == "Warriors"{
    return false
  }
  
  return name1 < name2
}

let favoriteFirstTeams = teams.sorted(by: favoriteFirstSorted)
print(favoriteFirstTeams)

let favoriteFirstTeams2 = teams.sorted(
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

let favoriteFirstTeams3 = teams.sorted {
  name1, name2 in
  if name1 == "Warriors" {
    return true
  } else if name2 == "Warriors" {
    return false
  }
  
  return name1 < name2
}

let favoriteFirstTeams4 = teams.sorted {
  if $0 == "Warriors" {
    return true
  } else if $1 == "Warriors" {
    return false
  }
  
  return $0 < $1
}

let reverseTeams = teams.sorted {
  return $0 > $1
}

let reverseTeams2 = teams.sorted {$0 > $1}

let wOnly = teams.filter { $0.hasPrefix("W") }
print(wOnly)

let uppercaseTeams = teams.map { $0.uppercased() }
print(uppercaseTeams)



func makeArray(size: Int, using generator: () -> Int) -> [Int] {
    var numbers = [Int]()

    for _ in 0..<size {
        let newNumber = generator()
        numbers.append(newNumber)
    }

    return numbers
}

let rolls = makeArray(size: 50) {
  Int.random(in: 1...20)
}
print(rolls)


func generateNumber() -> Int {
  Int.random(in: 1...20)
}

let newRolls = makeArray(size:50, using: generateNumber)
print(newRolls)


func doImportantWork(first: () -> Void, second: () -> Void, third: () -> Void) {
  print("About to start first work")
  first()
  print("About to start second work")
  second()
  print("About to start third work")
  third()
  print("Done!")
}

doImportantWork {
  print("This is the first work")
} second: {
  print("This is the second work")
} third: {
    print("This is the third work")
}
