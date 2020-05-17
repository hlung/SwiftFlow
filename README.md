# SwiftFlow

![logo](https://user-images.githubusercontent.com/652167/82144157-36701000-9879-11ea-94f4-eb576f007c4d.png)

- Draw flowchart in Swift! 🚀
- Define data in arrays of flow.
- Live editing (with SwiftUI live preview). 
- Good for small to medium sized flowcharts.
- Try out in [example project](https://github.com/hlung/SwiftFlowExample).


## Example

Generate this flow chart:

![output](https://user-images.githubusercontent.com/652167/81291213-f2705480-909b-11ea-9206-f3648cfac730.png)

From this code:

```swift
import SwiftFlow
```

```swift
let graph = Graph()

// setup configs
var blueConfig = NodeConfig()
blueConfig.backgroundColor = UIColor(red: 0.81, green: 0.96, blue: 1.00, alpha: 1.00)
var redConfig = NodeConfig()
redConfig.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 0.82, alpha: 1.00)

graph.nodeConfig = blueConfig

// add flows to graph
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
  ArrowLoopBack(from: .bottom, to: .right),
  NodeShortcut(id: "end")
])

let graphView = GraphView()
graphView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

// draw the graph!
try! graphView.draw(graph)
```

### Live preview in action with SwiftUI

![demo](https://user-images.githubusercontent.com/652167/81291197-edaba080-909b-11ea-9320-159b535751fd.gif)

* I'm actually wrapping `GraphView` in a SwiftUI's `UIViewRepresentable` type to enable live preview. While it is not the best way and fails sometimes, it usually can generate live preview after you make small changes.

## How to use

### Installation
- Search for "SwiftFlow" library in [Swift Packages](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) in Xcode 📦 

### Requirements

- iOS 13 and above
- I attempted to [support macOS](https://github.com/hlung/SwiftFlow/tree/feature/macos-support), but still doesn't work :(. See more details at the bottom.


## Why do you build this?

I often draw a flowchart to help understand some complex logic. It can also serves as a reference document for other engineers and testers.
To draw one, I usually use popular tools like https://docs.google.com/drawings or https://app.diagrams.net/. 
However, I find it **slow and tedious** to do simple stuff like node alignment, auto text content hugging, adding arrow between nodes, or just adding arrow annotation. 
Not to mention that most of these styling will be out of place one you insert new nodes in between or update existing text.

Working with UIKit autolayout for years makes me aware that all of these UI styling can be handled in code very easily.
Moreover, with the new SwiftUI, we can see **live previews** of the flowchart as we add each line of code. This will make flowchart drawing much faster and enjoyable.  

We can do it better! 💪


## Components ✍️

### Models

- `Node` - Each rectangle / other shapes boxes you see are backed by this type.
- `NodeShortcut` - A way to refer to an *existing* Node by `id`.
- `Arrow` - For chaining nodes together side-by-side. It has `direction` property for telling which way the arrow is pointing out from a node. You can also add annotations to it.
- `ArrowLoopBack` - Similar to Arrow, but it also support drawing an **angled** arrow to go around existing nodes, typically for looping back to an existing node above. It can be used for linking further away nodes that would look nicer using an angled arrow than a straight one.
- `NodeConfig` - For customizing a Node properties like background color / border color / distance from other nodes. A `Graph` can also take this property to apply to all nodes.
- `ArrowConfig` - For customizing an Arrow. 
- `GraphElement` - A protocol that all above types conforms to.
- `Graph` - This is the central piece that holds all information on how to draw the flowchart. 
  - You call `addFlow(_:)` which takes `[GraphElement]`. Typically, the array be a sequence of "`Node`, `Arrow`, `Node`, `Arrow`, ...".
  - Finally, you pass this type into `GraphView` and call `graphView.draw(graph)` to draw the view.

### Layout

- I use **autolayout** to put the nodes in place. The arrows, on the other hand, are drawn directly using exact coordinates derived from nodes already laid out. The `GraphView` respects `layoutMargins`, so you can adjust outer edge margins with it. 

## Future ideas 💡
This project is stil in early stage. Feel free to suggest features and fixes. 🙂
- export as image file
- allow multiple arrows in same direction
- add font/fontSize to NodeConfig
- add bold/italic/underline text
- add more node shapes
- dotted arrows?
- **markdown syntax support** - convert markdown syntax into SwiftFlow code. A very ambitious goal I would say. Not sure if there's a need for this though.
- **macOS support** - As an iOS developer, I built everything using UIKit. For macOS, those view components and UIBezierPath drawing code has to be translated into AppKit code. I attempted to create [AppKit+UIKit.swift](https://github.com/hlung/SwiftFlow/tree/feature/macos-support/Sources/SwiftFlow/AppKit%2BUIKit) extension that would provide AppKit components with UIKit interface. But I'm stuck at creating UIBezierPath cgPath setter. The code compiles on macOS but doesn't draw anything. You can try to fix in [feature/macos-support](https://github.com/hlung/SwiftFlow/tree/feature/macos-support) branch. So if you need a bigger canvas for the flowchart, just run it on an "iPad Simulator" for now. 😝


## Other Notes

### The name

I know some other library has the same name, like https://github.com/Swift-Kit/Swift-Flow . But I still prefer this name.

### Comparison with [mermaid](https://mermaidjs.github.io/#/) 🧜‍♀️

There is a JavaScript library for drawing flowchart in code called **mermaid**. (There's a [live editor](https://mermaid-js.github.io/mermaid-live-editor) you can try.)
At first glance it is very powerful. It can draw not only flowcharts, but may other types of diagrams. But I find there are some problems for drawing flowchart...

- **Node duplication** - The syntax is **link**-based, meaning each declaration includes 2 nodes and 1 arrow ( `A --> B`, `B --> C`, `C --> D` ). In a long flowchart, most nodes will appear  twice (`B` and `C`), which is very redundant. This won't happen if the syntax is **flow** based ( `A --> B --> C --> D` ) because most nodes will be referenced only once, except at the intersections. I think using **flow**-based syntax is cleaner and faster to write.
- **Ugly new line** - Need to use `<br />` 😫. I could just be `\n`.
- **Arrow is long** - It uses `-->` for an arrow. It could have been just `->` or `>`. This adds up with the link-based syntax mentioned.
- **Cannot specify arrow direction** - The graph declaration at the top dictates the arrow direction, e.g. `graph TD` means going from "top to bottom".
