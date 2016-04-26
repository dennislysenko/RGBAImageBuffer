# Contributing

Not really sure what there is left to contribute, but if you want to do something significant, just raise an issue. I'm pretty responsive when it comes to someone else wanting to do something to help me (aren't we all?). 

The only rules are that you always use `self` for property access and avoid forced unwrapping as much as possible. Name shadowing is very, very encouraged. 

For example:

```swift
class Car {
  var driver: Driver?
  var seat: Seat
  
  // ...
  
  func ejectDriver() {
    if let driver = self.driver {
      self.seat.ejectDriver(driver)
      self.driver = nil
    }
  }
}
```

## what do you get from these guidelines?
1. You'll stop using force unwraps in dangerous areas of code almost completely.
2. You always, always, always know exactly whether you're dealing with an optional instance variable or a bound local constant. 
3. You'll never feel like writing `if let w = self.window {` and littering your code with abbreviations again. Abbreviations both hamper readability and [go against Swift 3.0 API design guidelines](https://swift.org/documentation/api-design-guidelines/#use-terminology-well).
4. You'll stop using force unwraps in dangerous areas of code almost completely. 

Note how in the code snippet above, `driver` unambiguously refers to the bound local variable that is guaranteed to be non-null, while `self.driver` unambiguously refers to the mutable, nullable property. 

```swift
class Car {
  var driver: Driver?
  var seat: Seat
  
  // ...
  
  func ejectDriver() {
    if let driver = self.driver {
      self.seat.ejectDriver(driver)
      self.driver = nil
      // wait, where's the clutter from using self everywhere?
    }
  }
}
```

For comparison, here is the same example rewritten following the other school of thought:

```swift
class Car {
  var driver: Driver?
  var seat: Seat
  
  // ...
  
  func ejectDriver() {
    /* if let dr = driver { */
    // ^ let me stop you right there.
    
    if let driver = driver {
      seat.ejectDriver(driver)
      /* driver = nil */ // oh, oops, wrong variable. can't assign to a constant. drat
      self.driver = nil // well it works, but now I broke convention and it looks out of place
    }
  }
}
```
