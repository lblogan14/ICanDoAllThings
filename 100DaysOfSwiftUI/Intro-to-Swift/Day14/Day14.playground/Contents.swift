import Cocoa

var greeting = "Hello, playground"

//optionals
var username: String? = nil

if let unwrappedName = username {
  print("We got a user: \(unwrappedName)")
} else {
  print("The optional was empty.")
}

func printSquare(of number: Int?) {
  guard let number = number else{
    print("Missing input")
    return
  }
  
  print("\(number) x \(number) is \(number * number)")
}


func getMeaningOfLife() -> Int? {
  14
}

// if let
func printMeaningOfLife() {
  if let name = getMeaningOfLife() {
    print(name)
  }
}

// guard let
func printMeaningOfLife2() {
  guard let name = getMeaningOfLife() else {
    return
  }
  
  print(name)
}


// nil coalescing operator
let captains = [
  "Enterprice": "Picard",
  "Voyager": "JaneWay",
  "Defiant": "Sisko"
]
let new = captains["Serenity"] ?? "N/A"

let tvShows = ["Archer", "Babylon 5", "Ted Lasso"]
let favorite = tvShows.randomElement() ?? "None"

struct Book {
  let title: String
  let author: String?
}

let book = Book(title: "Beowulf", author: nil)
let author = book.author ?? "Anonymous"
print(author)

let input = ""
let number = Int(input) ?? 0
print(number)


// optional chaining
let names = ["Arya", "Bran", "Robb", "Sansa"]


//.                               |optional chaining
let chosen = names.randomElement()?.uppercased() ?? "No one"
print("Next in line: \(chosen)")

struct Book2 {
  let title: String
  let author: String?
}

var book2: Book2? = nil
let author2 = book2?.author?.first?.uppercased() ?? "A"
print(author2)

let names2 = ["Vincent": "van Gogh", "Pablo": "Picasso", "Claude": "Monet"]

let surnameLetter = names2["Vincent"]?.first?.uppercased() ?? "?"


enum UserError: Error {
  case badID, networkFailed
}

func getUser(id: Int) throws -> String {
  throw UserError.networkFailed
}

if let user = try? getUser(id: 23) {
  print("User: \(user)")
}
