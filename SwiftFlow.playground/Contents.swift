/* TODO
 - add arrow label
 - pill shape box
 - box borders
 - box background color
 - change leading/trailing to left/right ?
 Extras
 - arrow length multiplier
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
  public let shape: BoxShape
  public let title: String
  public let id: String

  public var description: String {
    return "[Box \(shape) title: \(title) id: \(id)]"
  }

  public init(shape: BoxShape, title: String, id: String = UUID().uuidString ) {
    self.shape = shape
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

public class ArrowDrawingPlan {
  public let startView: UIView
  public let endView: UIView
  public let arrow: Arrow

  public init(startView: UIView, endView: UIView, arrow: Arrow) {
    self.startView = startView
    self.endView = endView
    self.arrow = arrow
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
 Markdown legend:
 [], <>, () = box shape
 :: = box shortcut
 v  = arrow down
 >  = arrow right
 -----------------

 [] Start
 v
 <> Success? :: success
 v Yes
 [] Throw party!
 v
 [] End :: end

 :: success
 > No
 [] Cry
 v
 [] Go home
 v
 :: end
 */

let graph = Graph()

graph.addFlow([
  Box(shape: .rect, title: "Start"),
  Arrow(direction: .down, title: nil),
  Box(shape: .diamond, title: "Success?", id: "success"),
  Arrow(direction: .down, title: "Yes"),
  Box(shape: .rect, title: "Throw party!"),
  Arrow(direction: .down, title: nil),
  Box(shape: .rect, title: "End", id: "end"),
])

graph.addFlow([
  BoxShortcut(id: "success"),
  Arrow(direction: .right, title: "No"),
  Box(shape: .rect, title: "Cry"),
  Arrow(direction: .down, title: "No"),
  Box(shape: .rect, title: "Go home"),
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
var arrowDrawingPlans: [ArrowDrawingPlan] = []
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
          boxViewBefore = BoxView(Label(boxBefore.title), shape: boxBefore.shape)
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
          boxViewAfter = BoxView(Label(boxAfter.title), shape: boxAfter.shape)
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

      let plan = ArrowDrawingPlan(startView: boxViewBefore,
                                  endView: boxViewAfter,
                                  arrow: arrow)
      arrowDrawingPlans.append(plan)

//      print("-- \(boxBefore)\n   \(boxAfter)")
    }
  }
}

// Move boxes to correct places, so we can draw arrows using absolute coordinates.
PlaygroundPage.current.liveView = containerView

NSLayoutConstraint.activate(constraints)
print("constraints: \(constraints.count)")
print(constraints.map{ $0.description }.joined(separator: "\n"))
print("")
print("graphView.subviews: \(graphView.subviews.count)")
print(graphView.subviews.map{ $0.description }.joined(separator: "\n"))

// --- arrows ---
// We are not using autolayout for the arrows.
// So need to add arrows this AFTER all canstraints are activated and laid out.
graphView.layoutIfNeeded()

public extension UIView {
  func addArrowLayer(with plan: ArrowDrawingPlan) {
    let parameters = ArrowParameters(tailWidth: 2, headWidth: 7, headLength: 7)
    let startView: UIView = plan.startView
    let endView: UIView = plan.endView

    let layer: CAShapeLayer
    switch plan.arrow.direction {
    case .up:
      layer = CAShapeLayer.arrow(from: startView.frame.centerTop,
                                 to: endView.frame.centerBottom,
                                 parameters: parameters)
    case .right:
      layer = CAShapeLayer.arrow(from: startView.frame.centerRight,
                                 to: endView.frame.centerLeft,
                                 parameters: parameters)
    case .down:
      layer = CAShapeLayer.arrow(from: startView.frame.centerBottom,
                                 to: endView.frame.centerTop,
                                 parameters: parameters)
    case .left:
      layer = CAShapeLayer.arrow(from: startView.frame.centerLeft,
                                 to: endView.frame.centerRight,
                                 parameters: parameters)
    }
    self.layer.addSublayer(layer)
  }
}

for plan in arrowDrawingPlans {
  graphView.addArrowLayer(with: plan)
}

//graphView.addArrow(direction: .right, on: [
//  label_success,
//  label_cry,
//])

// ---------

//PlaygroundPage.current.needsIndefiniteExecution = true
