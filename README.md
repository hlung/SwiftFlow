# SwiftFlow

## Features
- Draw flowchart in Swift!
- Define data in arrays of flow. 
- Live editing (with SwiftUI live preview).
- Good for small to medium sized flowcharts.
- Try out in [example project](Example/SwiftFlowExample/ContentView.swift).

## Introduction

I often draw a flowchart to help understand some complex logic. It can also serves as a reference document for other engineers and testers.
To draw one, I usually use popular tools like https://docs.google.com/drawings or https://app.diagrams.net/. 
However, I find it **slow and tedious** to do simple stuff like node alignment, auto text content hugging, adding arrow between nodes, or just adding arrow annotation. 
Not to mention that most of these styling will be out of place one you insert new nodes in between or update existing text.

Working with UIKit autolayout for years makes me aware that all of these UI styling can be handled in code very easily.
Moreover, with the new SwiftUI, we can see **live previews** of the flowchart as we add each line of code. This will make flowchart drawing much faster and enjoyable.  

We could have done it better! 💪

## Design

### Comparison with [mermaid](https://mermaidjs.github.io/#/) 🧜‍♀️

Upon some research, the only popular way to write flowcharts in code is by using a 😫 "JavaScript" 😫 library called **mermaid**. (with a [live editor](https://mermaid-js.github.io/mermaid-live-editor) you can try.)
At first glance it is very powerful. It can draw not only flowcharts, but may other types of diagrams. But I find there are many problems...

- **Node duplication** - The syntax is **link**-based, meaning each declaration includes 2 nodes and 1 arrow ( e.g. `A --> B`, `B --> C`, `C --> D` ). So in a long flowchart, most of the nodes will appear  twice (`B` and `C` in this case). This won't happen if the syntax is **flow** based ( e.g. `A --> B --> C --> D` ). Since most nodes will be referenced only once, except at the intersections, I think using **flow**-based syntax is more suitable.
- **Ugly new line** - Need to use `<br />` 😫.
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

// Set up graph elements
graph.addFlow([
  Node(.pill, title: "Start"),
  Arrow(.down),
  Node(.diamond, title: "Work\nsuccess?", id: "success"), // declares id for later reference
  Arrow(.down, title: "Yes"),
  Node(.rect, title: "Go Party!"),
  Arrow(.down),
  Node(.pill, title: "End", id: "end")
])

graph.addFlow([
  NodeShortcut(id: "success"), // refers back to the Node above
  Arrow(.right, title: "No"), // branch out to the right side
  Node(.rect, title: "Cry", config: redConfig), // different color using config
  Arrow(.down),
  Node(.rect, title: "Go home"),
  Arrow(.down),
  NodeShortcut(id: "end")
])

let graphView = GraphView()
graphView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

// Call draw(_:) to draw the flowchart!
try! graphView.draw(graph)
```

### Output:
![Output](images/output2.png)


## How to use
- Install with Swift Package Manager


## Future plans 💡
This project is stil new. Feel free to suggest features and fixes. 🙂
- allow multiple arrows in same direction
- add font/fontSize to NodeConfig
- markdown syntax parser into SwiftFlow syntax


## Other Notes
- I know some other library has the same name, like https://github.com/Swift-Kit/Swift-Flow . But I still prefer this name.
