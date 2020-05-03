# SwiftFlow
🚧 Work in progress. 🚧

## Improvements over [mermaid](https://mermaidjs.github.io/#/)
- allow SPACE! in title of non-id boxes (nodes)
- compared to mermaid js
  - syntax is closer to the output than simply declaring all the links
  - allow new line character, no `<br />`
  - shorter arrow sign, e.g. `v` or `>` instead of `-->`
  - `id` comes *after* `name`
  - better loop back over old boxes
- arrow
  - has annotation
  - can specify preferred arrow direction (up, down, left, right, diagonal?)
- box
  - types: `[]` rectangle, `()` pill, `<>` diamond, `//` slanted, etc.
  - allow multiline text
- support live editing = Xcode playground + Autolayout. SwiftUI live preview is faster but layout is less flexible.
- can show error = Xcode playground

## Example

### Input Swift code
```swift
import SwiftFlow
```

```swift
let graph = Graph()

var blueConfig = NodeConfig()
blueConfig.backgroundColor = UIColor(red: 0.81, green: 0.96, blue: 1.00, alpha: 1.00) // #CFF5FF

var redConfig = NodeConfig()
redConfig.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 0.82, alpha: 1.00) // #FFCCD0

graph.nodeConfig = blueConfig

graph.addFlow([
  Node(.pill, title: "Start"),
  Arrow(.down),
  Node(.diamond, title: "Work\nsuccess?", id: "success"),
  Arrow(.down, title: "Yes"),
  Node(.rect, title: "Go Party!"),
  Arrow(),
  Node(.pill, title: "End", id: "end"),
])

graph.addFlow([
  NodeShortcut(id: "success"),
  Arrow(.right, title: "No"),
  Node(.rect, title: "Cry", config: redConfig),
  Arrow(),
  Node(.rect, title: "Go home"),
  Arrow(),
  NodeShortcut(id: "end"),
])

let graphView = GraphView()
graphView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
try! graphView.draw(graph)
```
  
### Output Flowchart
![Output](images/output2.png)

### Notes
- I know the SwiftFlow name conflicts with https://github.com/Swift-Kit/Swift-Flow , but I don't care :P.

## Extra feature ideas

These below are just just ideas. 💡

### String format

For those not familiar with Swift language, strings can be used to create the flowchart as well, similar to markdown format.

```swiftflow
 -----------------
 Legend:
 [], <>, () = box shape
 :: = box shortcut
 v  = arrow down
 >  = arrow right
 -----------------

 () Start
 v
 <> Work\nSuccess? :: success
 v Yes
 [] Go party!
 v
 () End :: end

 :: success
 > No
 [] Cry
 v
 [] Go home
 v
 :: end
```
