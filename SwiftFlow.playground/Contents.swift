/* TODO
 - add arrow label
 - add Box borders
 - change leading/trailing to left/right ?
 Extras
 - all boxes margin constraints (avoid different flow colliding) ?
 - check duplicate id
 */

import UIKit
import PlaygroundSupport

// --- base model ---

public class Graph {
  var flows: [[GraphElement]] = []

  func addFlow(_ elements: [GraphElement]) {
    flows.append(elements)
  }
}

public protocol GraphElement {}

public struct Box: GraphElement, CustomStringConvertible {
  public let type: BoxType
  public let title: String
  public let id: String

  public var description: String {
    return "[Box \(type) title: \(title) id: \(id)]"
  }

  public init(type: BoxType, title: String, id: String = UUID().uuidString ) {
    self.type = type
    self.title = title
    self.id = id
  }
}

public struct BoxShortcut: GraphElement, CustomStringConvertible {
  let id: String

  public var description: String {
    return "[BoxShortcut id: \(id)]"
  }
}

public struct Arrow: GraphElement, CustomStringConvertible {
  let direction: Direction
  let title: String?

  public var description: String {
    return "[Arrow \(direction) title \(title ?? "-")]"
  }
}

// --- UI preparation ---

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 400, height: 500))
containerView.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0)
let graphView = GraphView()
graphView.layoutMargins = UIEdgeInsets(shrinkingBy: 20)
graphView.subviewPadding = 20

var constraints: [NSLayoutConstraint] = []

containerView.addSubview(graphView)
constraints += [
  graphView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
  graphView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
]

// --- data ---
/*
 -----------------
 Legend:
 :: = id
 [], <> = box type
 v = arrow down
 -----------------

 [] Start
 v
 [] API Client receives responses
 v
 <> Success?
 > NO [] Handle failure :: result_no
 v YES [] Handle success :: result_yes
 v
 [] Print Yay
 result_no
 v
 [] Print Cry
 vv
 [] End

 */

let graph = Graph()

graph.addFlow([
  Box(type: .rect, title: "Start"),
  Arrow(direction: .down, title: nil),
  Box(type: .diamond, title: "Success?", id: "success"),
  Arrow(direction: .down, title: "Yes"),
  Box(type: .rect, title: "Celebrate!"),
  Arrow(direction: .down, title: nil),
  Box(type: .rect, title: "End", id: "end"),
])

graph.addFlow([
  BoxShortcut(id: "success"),
  Arrow(direction: .right, title: "No"),
  Box(type: .rect, title: "Cry"),
  Arrow(direction: .down, title: "No"),
  Box(type: .rect, title: "Go home"),
  Arrow(direction: .down, title: nil),
  BoxShortcut(id: "end"),
])

// --- drawing ---

extension GraphView {
  public func boxViewWithID(_ id: String) -> BoxView? {
    return self.subviews.first(where: { view in
      if let view = view as? BoxView, view.id == id { return true }
      else { return false }
    }) as? BoxView
  }

  public func addSubviewIfNeeded(_ view: UIView) {
    //guard (self.subviews.first(where: { $0 == view }) == nil) else { return }
    super.addSubview(view)
    view.layoutMargins = UIEdgeInsets(expandingBy: subviewPadding)
    NSLayoutConstraint.activate([
      topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
      leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
      bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
      trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
    ])
  }
}

var prevBox: Box?
var prevArrow: Arrow?
//var arrows: [(UIView, UIView)] = []
for flow in graph.flows {
  guard flow.count > 0 else { continue }

  for index in 1..<flow.count {
    let e = flow[index]

    if let arrow = e as? Arrow, index+1 < flow.count {

      let boxViewBefore: BoxView
      var boxViewBeforeIsNew = false
      let elementBefore = flow[index-1]
      if let boxBefore = elementBefore as? Box {
        if let existing = graphView.boxViewWithID(boxBefore.id) {
          boxViewBefore = existing
        }
        else {
          boxViewBefore = BoxView(Label(boxBefore.title), type: boxBefore.type)
          boxViewBefore.id = boxBefore.id
          graphView.addSubviewIfNeeded(boxViewBefore)
          boxViewBeforeIsNew = true
        }
      }
      else if let boxShortcutBefore = elementBefore as? BoxShortcut,
        let view = graphView.boxViewWithID(boxShortcutBefore.id) {
        boxViewBefore = view
      }
      else {
        fatalError("Cannot find box before arrow")
      }

      let boxViewAfter: BoxView
      var boxViewAfterIsNew = false
      let elementAfter = flow[index+1]
      if let boxAfter = elementAfter as? Box {
        if let existing = graphView.boxViewWithID(boxAfter.id) {
          boxViewAfter = existing
        }
        else {
          boxViewAfter = BoxView(Label(boxAfter.title), type: boxAfter.type)
          boxViewAfter.id = boxAfter.id
          graphView.addSubviewIfNeeded(boxViewAfter)
          boxViewAfterIsNew = true
        }
      }
      else if let boxShortcutAfter = elementAfter as? BoxShortcut,
        let view = graphView.boxViewWithID(boxShortcutAfter.id) {
        boxViewAfter = view
      }
      else {
        fatalError("Cannot find box after arrow")
      }

      if boxViewBeforeIsNew || boxViewAfterIsNew {
        constraints += boxViewBefore.constraints(direction: arrow.direction,
                                                 to: boxViewAfter)
      }

//      print("-- \(boxBefore)\n   \(boxAfter)")
    }
  }
}

//constraints += [
//  label_start,
//  label_api_call,
//  label_success,
//  label_yay,
//  label_end
//  ].constrainTopToBottom()

// Move boxes to correct places, so we can draw arrows using absolute coordinates.
PlaygroundPage.current.liveView = containerView

NSLayoutConstraint.activate(constraints)
print("constraints: \(constraints.count)")
print(constraints.map{ $0.description }.joined(separator: "\n"))
print("")
print("graphView.subviews: \(graphView.subviews.count)")
print(graphView.subviews.map{ $0.description }.joined(separator: "\n"))

// We are not using autolayout for the arrows.
// So need to add arrows this AFTER all canstraints are activated and laid out.
//graphView.layoutIfNeeded()
//graphView.addArrow(direction: .down, on: [
//  label_start,
//  label_api_call,
//  label_success,
//  label_yay,
//  label_end
//])

//graphView.addArrow(direction: .right, on: [
//  label_success,
//  label_cry,
//])

// ---------

//PlaygroundPage.current.needsIndefiniteExecution = true
