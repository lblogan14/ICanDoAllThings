import Cocoa

var greeting = "Hello, playground"

// type annotations
let surname: String = "Lasso"
var score: Int = 0
var score2: Double = 0

let playerName: String = "Steph"
var luckyNumber: Int = 14
let pi: Double = 3.1415
var isAuthenticated: Bool = true

var albums: [String] = ["Red", "Fearless"]

var user: [String: String] = ["id": "@twostraws"]

var books: Set<String> = Set(["The Bluest Eye", "Foundation", "Girl, Woman, Other"])

var teams: [String] = [String]()

enum UIStyle {
  case light, dark, system
}
var style = UIStyle.light

let username: String
// ...more processing
username = "@twostraws"
// ...more processing
print(username)
