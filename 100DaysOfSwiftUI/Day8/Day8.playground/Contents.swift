import Cocoa

var greeting = "Hello, playground"

func printTimesTables(for number: Int, end: Int) {
  for i in 1...end {
    print("\(i) x \(number) is \(i * number)")
  }
}

printTimesTables(for: 5, end: 20)


func printTimesTables2(for number: Int, end: Int = 12) {
  for i in 1...end {
    print("\(i) x \(number) is \(i * number)")
  }
}

printTimesTables2(for: 5, end: 20)
printTimesTables2(for: 8)


var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)
characters.removeAll()
print(characters.count)

characters.removeAll(keepingCapacity: true)


// Throw errors
enum PasswordError: Error {
  case short, obvious
}

func checkPassword(_ password: String) throws -> String {
  if password.count < 5 {
    throw PasswordError.short
  }
  
  if password == "12345" {
    throw PasswordError.obvious
  }
  
  if password.count < 8 {
    return "OK"
  } else if password.count < 10 {
    return "Good"
  } else {
    return "Excellent"
  }
}

let pw = "12345"

do {
  let result = try checkPassword(pw)
  print("Password rating: \(result)")
} catch {
  print("There was an error.")
}


let pw2 = "12345"

do {
  let result = try checkPassword(pw2)
  print("Password rating: \(result)")
} catch PasswordError.short {
  print("Please use a longer password.")
} catch PasswordError.obvious {
  print("I have the same combination on my luggage!")
} catch {
  print("There was an error.")
}
