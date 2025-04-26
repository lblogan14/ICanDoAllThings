# Day 2 - Simple Data Types

## Storing Booleans

```swift
let filename = 'basketball.jpg'
print(filename.hasSuffix('.jpg'))
let num = 120
print(num.isMultiple(of: 4))
```

Create boolean values:

```swift
let goodDogs = true
let gameOver = false
```

We can also assign a boolean value from other code:

```swift
let isMultiple = 120.isMultiple(of: 3)
```

Booleans do not have arithmetic operators, but booleans have a special operator, `!`, which means "not".

```swift
var isAuthenticated = false
isAuthenticated = !isAuthenticated
print(isAuthenticated)
isAuthenticated = !isAuthenticated
print(isAuthenticated)
```

If we can `toggle()` function on a boolean, it will flip a true value to false, and a false value to true.

```swift
var gameOver = false
print(gameOver)
gameOver.toggle()
print(gameOver)
```

This is the same is using `!`.