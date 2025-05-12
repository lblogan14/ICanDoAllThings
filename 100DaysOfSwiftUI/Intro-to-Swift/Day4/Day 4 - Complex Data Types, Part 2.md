# Day 4 - Complex Data Types, Part 2

## Using Type Annotations

```swift
let surname = "Lasso"
var score = 0
```

This uses *type inference*: Swift *infers* that `surname` is a string because we assigned text to it, and then infers that `score` is an integer because we assigned a whole number to it.

**Type annotations** let us be explicit about what data types we want:

```swift
let surname: String = "Lasso"
var score: Int = 0
```

This is useful because sometimes we want to choose a different type:

```swift
var score2: Double = 0
```

WIthout the `: Double`, Swift would infer that to be an integer.

More examples:

```swift
let playerName: String = "Steph"
var luckyNumber: Int = 14
let pi: Double = 3.1415
var isAuthenticated: Bool = true
```

`Array` example:

```swift
var albums: [String] = ["Red", "Fearless"]
```

`Dictionary` example:

```swift
var user: [String: String] = ["id": "@twostraws"]
```

`Set` example:

```swift
var books: Set<String> = Set(["The Bluest Eye", "Foundation", "Girl, Woman, Other"])
```

What makes type annotation is useful is to put a placeholder:

```swift
var teams: [String] = [String]()
```

The type annotation is not required here, but we still need to know that an array of strings is written as `[String]` so that we can make the thing. NOTE: We need to **add the open and close parentheses when making empty arrays, dictionaries, and sets.**

Enums are a little different from the others because they let us create new types of our own, such as an enum containing days of the week we created in the Day 3 session.

Values of an enum have the same type as the enum itself, so we could write:

```swift
enum UIStyle {
  case light, dark, system
}
var style = UIStyle.light
```

This is what allows Swift to remove the enum name for future assignments, so we can write `style = .dark` - it knows any new value for `style` must be some kind `UIStyle`.

The most common use case for type annotation is with constants we do not have values for yet. We can create a constant that does not have a value just yet, later on provide that value, and Swift will ensure we do not accidentally use it until a value is present:

```swift
let username: String
// ...more processing
username = "@twostraws"
// ...more processing
print(username)
```

We initialize that `username` will contain a string at some point, and we provide a value before using it.

## Summary

- **Arrays** let us store lots of values in one place, and then read them out using integer indices.
- **Dictionaries** let us store lots of values in one place, but let us read them out using keys we specify.
- **Sets** also let us store lots of values in one place, but we do not get to choose the order in which they store those items. Sets are really efficient at finding whether they contain a specific item.
- **Enums** let us create our own simple types in Swift so that we can specify a range of acceptable values such as a list of actions the user can perform.
- Swfit must always know the type of data inside a constant or variable, and mustly uses type inference to figure out based on the data we assign.