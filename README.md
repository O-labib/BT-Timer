# BT-Timer

[![Version](https://img.shields.io/cocoapods/v/BT-Timer.svg?style=flat)](https://cocoapods.org/pods/BT-Timer)
[![License](https://img.shields.io/cocoapods/l/BT-Timer.svg?style=flat)](https://cocoapods.org/pods/BT-Timer)
[![Platform](https://img.shields.io/cocoapods/p/BT-Timer.svg?style=flat)](https://cocoapods.org/pods/BT-Timer)

## Timer
![Alt Text](https://media.giphy.com/media/ZXeHQZzYYhHZIosaSt/giphy.gif)

#### Setup
**1- Initialize** BTtimer specifying...
- The label it should be linked to.
- The time it should countdown.
- whether the label should be animating or not.

```swift
  let timer:BTtimer!
  override func viewDidLoad() {
      ...
      timer = BTtimer(for: label, withTimeInSecs: 1 * 60 * 60, animate: true)
  }
```
**2- Control** the timer
```swift
  timer.fire()
  timer.pause()
  timer.stop()
  timer.reset()
```

**3- Implement** BTtimerDelegate with the available functions...
```swift
extension UIViewController : BTtimerDelegate {
    public func didStart() { }
    
    public func didTick(with secondsLeft: Int) { }
    
    public func ditTimeOutWhileInBackground(since secondsPassed: Int) { }
    
    public func didTimeOut() { }
}
```
## Stopwatch
![Alt Text](https://media.giphy.com/media/Y2tTdRujHE9RpZuEL2/giphy.gif)

#### Setup
**1- Initialize** BTstopwatch specifying...
- The label it should be linked to.
- whether the label should be animating or not.

```swift
  stopwatch:BTstopwatch!
  override func viewDidLoad() {
      ...
      stopwatch = BTstopwatch(for: label, animated: true)
  }
```
**2- Control** the timer
```swift
  stopwatch.fire()
  stopwatch.pause()
  stopwatch.stop()
  stopwatch.restart()
```

**3- Implement** StopwatchDelegate with the available functions...
```swift
extension UIViewController : StopwatchDelegate {
    public func stopwatchWasInterrupted(at timePassedInSec:Int) { }
}
```

## Installation
BT-Timer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BT-Timer'
```

## Author

Omar Labib, o.labib1995@gmail.com

## License

BT-Timer is available under the MIT license. See the LICENSE file for more info.
