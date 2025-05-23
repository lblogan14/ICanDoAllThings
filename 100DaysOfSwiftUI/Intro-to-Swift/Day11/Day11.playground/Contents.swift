import Cocoa

var greeting = "Hello, playground"

struct BankAccount {
  var funds = 0
  
  mutating func deposit(amount: Int) {
    funds += amount
  }
  
  mutating func withdraw(amount: Int) -> Bool {
    if funds >= amount {
      funds -= amount
      return true
    } else {
      return false
    }
  }
}

var account = BankAccount()
account.deposit(amount: 100)

let success = account.withdraw(amount: 200)

if success {
  print("Withdrew money successfully")
} else {
  print("Failed to get the money")
}

account.funds -= 1000


struct BankAccount2 {
  // funds is private now
  private var funds = 0
  
  mutating func deposit(amount: Int) {
    funds += amount
  }
  
  mutating func withdraw(amount: Int) -> Bool {
    if funds >= amount {
      funds -= amount
      return true
    } else {
      return false
    }
  }
}


// static properties and methods
struct School {
  static var studentCount = 0
  
  static func add(student: String) {
    print("\(student) joined the school.")
    studentCount += 1
  }
}

School.add(student: "Steph Curry")
print(School.studentCount)

struct AppData {
  static let version = "1.3 beta 2"
  static let saveFilename = "settings.json"
  static let homeURL = "https://www.hackingwithswift.com"
}


struct Employee {
  let username: String
  let password: String
  
  static let example = Employee(
      username: "kai11",
    password: "artistonthecourt"
  )
}
