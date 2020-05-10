# SwiftFlow

![demo](https://user-images.githubusercontent.com/652167/81291197-edaba080-909b-11ea-9320-159b535751fd.gif)


## Features
- Draw flowchart in Swift! 🚀
- Define data in arrays of flow.
- Live editing (with SwiftUI live preview). 
- Good for small to medium sized flowcharts.
- Try out in [example project](https://github.com/hlung/SwiftFlowExample).

## Installation
- Search for "SwiftFlow" library in [Swift Packages](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) in Xcode 📦 

## Requirements

- iOS 13 and above

## Story

I often draw a flowchart to help understand some complex logic. It can also serves as a reference document for other engineers and testers.
To draw one, I usually use popular tools like https://docs.google.com/drawings or https://app.diagrams.net/. 
However, I find it **slow and tedious** to do simple stuff like node alignment, auto text content hugging, adding arrow between nodes, or just adding arrow annotation. 
Not to mention that most of these styling will be out of place one you insert new nodes in between or update existing text.

Working with UIKit autolayout for years makes me aware that all of these UI styling can be handled in code very easily.
Moreover, with the new SwiftUI, we can see **live previews** of the flowchart as we add each line of code. This will make flowchart drawing much faster and enjoyable.  

We could have done it better! 💪

## Design

### Comparison with [mermaid](https://mermaidjs.github.io/#/) 🧜‍♀️

After some research, I found one JavaScript😫 library for drawing flowchart in code called **mermaid**. (There's a [live editor](https://mermaid-js.github.io/mermaid-live-editor) you can try.)
At first glance it is very powerful. It can draw not only flowcharts, but may other types of diagrams. But I find there are some problems for drawing flowchart...

- **Node duplication** - The syntax is **link**-based, meaning each declaration includes 2 nodes and 1 arrow ( `A --> B`, `B --> C`, `C --> D` ). In a long flowchart, most nodes will appear  twice (`B` and `C`), which is very redundant. This won't happen if the syntax is **flow** based ( `A --> B --> C --> D` ) because most nodes will be referenced only once, except at the intersections. I think using **flow**-based syntax is cleaner and faster to write.
- **Ugly new line** - Need to use `<br />` 😫. I could just be `\n`.
- **Arrow is long** - It uses `-->` for an arrow. It could have been just `->` or `>`. This adds up with the link-based syntax mentioned.
- **Cannot specify arrow direction** - The graph declaration at the top dictates the arrow direction, e.g. `graph TD` means going from "top to bottom".

### Data modeling

- At top level, we have a `GraphView` that takes a `Graph` object which holds all information about the flowchart.
- We set up the `Graph` by adding arrays of `GraphElement` conformed types, which includes `Node`, `NodeShortcut`, and `Arrow`.
- Each `Node` can be customized using `NodeConfig`, like background and border color.

### Layout

- I use **autolayout** to put the nodes in place. The arrows, on the other hand, are drawn directly using exact coordinates derived from nodes already laid out.
- In the example project, the `GraphView` is wrapped in SwiftUI's `UIViewRepresentable` type to enable live preview.
- I use iOS `UIKit` instead of `AppKit` because I'm more familiar with iOS development. It could be rewritten if needed for a macOS app.

## Example

### Input Swift code:
```swift
import SwiftFlow
```

```swift
let graph = Graph()

var blueConfig = NodeConfig()
blueConfig.backgroundColor = UIColor(red: 0.81, green: 0.96, blue: 1.00, alpha: 1.00)

var redConfig = NodeConfig()
redConfig.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 0.82, alpha: 1.00)

graph.nodeConfig = blueConfig

// setup flows
graph.addFlow([
  Node("Start", shape: .pill),
  Arrow(.down),
  Node("Work\nsuccess?", shape: .diamond, id: "success"), // declare id for later reference
  Arrow(.down, title: "Yes"),
  Node("Go Party!", shape: .rect, id: "party"),
  Arrow(.down),
  Node("End", shape: .pill, id: "end")
])

graph.addFlow([
  NodeShortcut(id: "success"), // refers back to the Node above
  Arrow(.right, title: "No"), // branch out to the right side
  Node("Cry", shape: .rect, config: redConfig), // different color using config
  Arrow(.down),
  Node("Go home", shape: .rect, id: "home"),
])

graph.addFlow([
  NodeShortcut(id: "home"),
  ArrowLoopBack(from: .bottom, to: .right),
  NodeShortcut(id: "end")
])

let graphView = GraphView()
graphView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

// Call draw(_:) to draw the flowchart!
try! graphView.draw(graph)
```

### Output:
![output](https://user-images.githubusercontent.com/652167/81291213-f2705480-909b-11ea-9206-f3648cfac730.png)


## Future plans 💡
This project is stil new. Feel free to suggest features and fixes. 🙂
- allow multiple arrows in same direction
- add font/fontSize to NodeConfig
- markdown syntax parser into SwiftFlow syntax
- merge arrow heads 🏹

## Other Notes
- I know some other library has the same name, like https://github.com/Swift-Kit/Swift-Flow . But I still prefer this name.
