/* TODO
 - change leading/trailing to left/right ?
 Extras
 - add errors: check duplicate id
 - avoid collissions: between boxes, box and arrow labels
 */

import UIKit
import PlaygroundSupport

// --- data ---

var graph = Graph()

var blueBoxConfig = BoxConfig()
blueBoxConfig.backgroundColor = UIColor(hex: "9EE5FF")!
graph.boxConfig = blueBoxConfig

var redBoxConfig = BoxConfig()
redBoxConfig.backgroundColor = UIColor(hex: "FFCCD0")!

graph.addFlow([
  Box(shape: .pill, title: "Start"),
  Arrow(direction: .down),
  Box(shape: .diamond, title: "Work\nsuccess?", id: "success"),
  Arrow(direction: .down, title: "Yes"),
  Box(shape: .rect, title: "Go Party!"),
  Arrow(direction: .down),
  Box(shape: .pill, title: "End", id: "end"),
])

graph.addFlow([
  BoxShortcut(id: "success"),
  Arrow(direction: .right, title: "No"),
  Box(shape: .rect, title: "Cry", config: redBoxConfig),
  Arrow(direction: .down),
  Box(shape: .rect, title: "Go home"),
  Arrow(direction: .down),
  BoxShortcut(id: "end"),
])

// --- UI ---

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 400, height: 500))
containerView.backgroundColor = UIColor(hex: "9EFFB6")

var constraints: [NSLayoutConstraint] = []
let graphView = GraphView()
graphView.layoutMargins = UIEdgeInsets(shrinkingBy: 20)
containerView.addSubview(graphView)
constraints += [
  graphView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
  graphView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
]

var arrowDrawingPlans: [ArrowDrawingPlan] = []

for flow in graph.flows {
  guard flow.count > 0 else { continue }

  for index in 1..<flow.count {
    let e = flow[index]

    if let arrow = e as? Arrow, index+1 < flow.count {
      // Box before
      let boxViewBefore: BoxView
      var boxViewBeforeIsNew = false
      let elementBefore = flow[index-1]
      if let boxBefore = elementBefore as? Box {
        if let existing = graphView.boxViewWithID(boxBefore.id) {
          boxViewBefore = existing
        }
        else {
          let config = boxBefore.config ?? graph.boxConfig
          boxViewBefore = BoxView(Label(boxBefore.title), shape: boxBefore.shape, config: config)
          boxViewBefore.id = boxBefore.id
          graphView.addBoxView(boxViewBefore)
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

      // Box after
      let boxViewAfter: BoxView
      var boxViewAfterIsNew = false
      let elementAfter = flow[index+1]
      if let boxAfter = elementAfter as? Box {
        if let existing = graphView.boxViewWithID(boxAfter.id) {
          boxViewAfter = existing
        }
        else {
          let config = boxAfter.config ?? graph.boxConfig
          boxViewAfter = BoxView(Label(boxAfter.title), shape: boxAfter.shape, config: config)
          boxViewAfter.id = boxAfter.id
          graphView.addBoxView(boxViewAfter)
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

      // Add constraints and arrows
      if boxViewBeforeIsNew || boxViewAfterIsNew {
        let offset = EdgeOffsets.offset(from: boxViewBefore.config.edgeOffsets,
                                        to: boxViewAfter.config.edgeOffsets,
                                        direction: arrow.direction)
        constraints += boxViewBefore.constraints(direction: arrow.direction,
                                                 to: boxViewAfter,
                                                 offset: offset)
      }

      let plan = ArrowDrawingPlan(startView: boxViewBefore,
                                  endView: boxViewAfter,
                                  arrow: arrow)
      arrowDrawingPlans.append(plan)
    }
  }
}

// Move boxes to correct places, so we can draw arrows using absolute coordinates.
PlaygroundPage.current.liveView = containerView
//PlaygroundPage.current.needsIndefiniteExecution = true

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

for plan in arrowDrawingPlans {
  graphView.addArrow(plan, defaultConfig: graph.arrowConfig)
}

// --------------

public extension GraphView {
  func addArrow(_ plan: ArrowDrawingPlan, defaultConfig: ArrowConfig) {
    let config = plan.arrow.config ?? defaultConfig
    let startView: UIView = plan.startView
    let endView: UIView = plan.endView

    if let title = plan.arrow.title {
      let label = Label(title)
      label.font = .systemFont(ofSize: 14)
      addSubview(label)
      let spacing = config.tailWidth + 1
      let spacingFromBeginning: CGFloat = 2
      let labelConstraints: [NSLayoutConstraint]
      switch plan.arrow.direction {
      case .up:
        labelConstraints = [
          label.leftAnchor.constraint(equalTo: startView.centerXAnchor, constant: spacing),
          label.bottomAnchor.constraint(equalTo: startView.topAnchor, constant: -spacingFromBeginning),
        ]
      case .right:
        labelConstraints = [
          label.leftAnchor.constraint(equalTo: startView.rightAnchor, constant: spacingFromBeginning),
          label.bottomAnchor.constraint(equalTo: startView.centerYAnchor, constant: -spacing),
        ]
      case .down:
        labelConstraints = [
          label.leftAnchor.constraint(equalTo: startView.centerXAnchor, constant: spacing),
          label.topAnchor.constraint(equalTo: startView.bottomAnchor, constant: spacingFromBeginning),
        ]
      case .left:
        labelConstraints = [
          label.rightAnchor.constraint(equalTo: startView.leftAnchor, constant: -spacingFromBeginning),
          label.bottomAnchor.constraint(equalTo: startView.centerYAnchor, constant: -spacing),
        ]
      }
      NSLayoutConstraint.activate(labelConstraints)
    }

    let layer: CAShapeLayer
    switch plan.arrow.direction {
    case .up:
      layer = CAShapeLayer.arrow(from: startView.frame.centerTop,
                                 to: endView.frame.centerBottom,
                                 config: config)
    case .right:
      layer = CAShapeLayer.arrow(from: startView.frame.centerRight,
                                 to: endView.frame.centerLeft,
                                 config: config)
    case .down:
      layer = CAShapeLayer.arrow(from: startView.frame.centerBottom,
                                 to: endView.frame.centerTop,
                                 config: config)
    case .left:
      layer = CAShapeLayer.arrow(from: startView.frame.centerLeft,
                                 to: endView.frame.centerRight,
                                 config: config)
    }
    self.layer.addSublayer(layer)
  }
}

// --- base model ---

public class Graph {
  var flows: [[GraphElement]] = []
  var boxConfig = BoxConfig()
  var arrowConfig = ArrowConfig()

  func addFlow(_ elements: [GraphElement]) {
    flows.append(elements)
  }
}

public protocol GraphElement {}

public struct Box: GraphElement, CustomStringConvertible {
  public let shape: BoxShape
  public let title: String
  public let id: String
  public let config: BoxConfig?

  public var description: String {
    return "[Box \(shape) title: \(title) id: \(id)]"
  }

  public init(shape: BoxShape,
              title: String,
              id: String = UUID().uuidString,
              config: BoxConfig? = nil) {
    self.shape = shape
    self.title = title
    self.id = id
    self.config = config
  }
}

public struct BoxShortcut: GraphElement, CustomStringConvertible {
  public let id: String

  public var description: String {
    return "[BoxShortcut id: \(id)]"
  }
}

public struct Arrow: GraphElement, CustomStringConvertible {
  public let direction: Direction
  public let title: String?
  public let config: ArrowConfig?

  public var description: String {
    return "[Arrow \(direction) title \(title ?? "-")]"
  }

  public init(direction: Direction,
              title: String? = nil,
              config: ArrowConfig? = nil) {
    self.direction = direction
    self.title = title
    self.config = config
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
