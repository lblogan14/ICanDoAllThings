import Cocoa

var greeting = "Hello, playground"

// arrays
var gsw = ["Steph", "Klay", "Kevin"]
let numbers = [4, 8, 15, 16, 23, 42]
var temperatures = [25.3, 28.2, 26.4]

print(gsw[0])
print(numbers[1])
print(temperatures[2])

gsw.append("Jimmy")
gsw.append("Kyrie")
gsw.append("Derrick")
print(gsw)

// Uncomme to see error
//temperatures.append('Chirs')

var scores = Array<Int>()
scores.append(100)
scores.append(80)
scores.append(85)
print(scores)

var albums = Array<String>()
albums.append("Folklore")
albums.append("Fearless")
albums.append("Red")

var albums2 = [String]()
albums2.append("Folklore")
albums2.append("Fearless")
albums2.append("Red")

var albums3 = ["Folklore"]
albums3.append("Fearless")
albums3.append("Red")

print(albums.count)

var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)
print(characters)

characters.remove(at: 2)
print(characters)

characters.removeAll()
print(characters)

let bondMovies = ["Casino Royale", "Spectre", "No Time To Die"]
print(bondMovies.contains("Frozen"))

let cities = ["London", "Tokyo", "Rome", "Qingdao"]
print(cities.sorted())

let gswStars = ["Curry", "Thompson", "Durant", "Green"]
let reversedGswStars = gswStars.reversed()
print(reversedGswStars)


// dictionary
let player = ["name": "Steph Curry", "job": "basketball player", "team": "GSW"]
let player2 = [
  "name": "Steph Curry",
  "job": "basketball player",
  "team": "GSW"
]
print(player["name"])
print(player["job"])
print(player["team"])
// Uncomment to see error
//print(player("password"))

print(player["name", default: "Unknown"])
print(player["job", default: "Unknown"])
print(player["team", default: "Unknown"])
print(player["password", default: "Unknown"])

let hasGraduated = [
  "Eric": false,
  "Maeve": true,
  "Otis": false,
]

let olympics = [
  2012: "London",
  2016: "Rio de Janeiro",
  2021: "Tokyo"
]

var heights = [String: Int]()
heights["Yao Ming"] = 229
heights["Shaquille O'Neal"] = 216
heights["Steph Curry"] = 191

var archEnemies = [String: String]()
archEnemies["Batman"] = "The Joker"
archEnemies["Superman"] = "Lex Luthor"
archEnemies["Batman"] = "Penguin"
print(archEnemies["Batman", default: "Unknown"])

print(heights.count)
print(archEnemies.removeAll())

let people = Set(["Denzel Washington", "Tom Cruise", "Nicolas Cage", "Samuel L Jackson"])

var people2 = Set<String>()
people2.insert("Denzel Washington")
people2.insert("Tom Cruise")
people2.insert("Nicolas Cage")
people2.insert("Samuel L Jackson")

print(people.count)
print(people.sorted())


// enum
enum Weekday {
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
}
var day = Weekday.monday
day = Weekday.tuesday
day = Weekday.friday

enum Weekday2 {
  case monday, tuesday, wednesday, thursday, friday
}

var day2 = Weekday2.monday
day2 = .tuesday
day2 = .friday
