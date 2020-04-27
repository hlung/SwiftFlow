/* TODO
 - Rename Box to Node
 Extras
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

//graph.addFlow([
//  Box(shape: .pill, title: "Start"),
//])

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
  NodeShortcut(id: "success"),
  Arrow(direction: .right, title: "No"),
  Box(shape: .rect, title: "Cry", config: redBoxConfig),
  Arrow(direction: .down),
  Box(shape: .rect, title: "Go home"),
  Arrow(direction: .down),
  NodeShortcut(id: "end"),
])

// --- UI ---

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 400, height: 500))
containerView.backgroundColor = UIColor(hex: "EAEAEA")

var constraints: [NSLayoutConstraint] = []
let graphView = GraphView()
graphView.layoutMargins = UIEdgeInsets(shrinkingBy: 20)
containerView.addSubview(graphView)
constraints += [
  graphView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
  graphView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
]
NSLayoutConstraint.activate(constraints)

extension GraphView {

  func draw(_ graph: Graph) throws {

    var arrowDrawingPlans: [ArrowDrawingPlan] = []
    var constraints: [NSLayoutConstraint] = []

    for flow in graph.flows {
      guard !flow.isEmpty else { throw GraphViewError.graphIsEmpty }

      var savedNodeView: BoxView
      var savedArrow: Arrow? = nil

      // Draw first node
      if let firstNode = flow.first as? Box {
        let view = BoxView(box: firstNode, config: firstNode.config ?? graph.boxConfig)
        self.addBoxView(view)
        savedNodeView = view
      }
      else if let firstShortcut = flow.first as? NodeShortcut {
        guard let view = self.existingBoxView(with: firstShortcut.id) else {
          throw GraphViewError.shortcutNodeNotFound
        }
        savedNodeView = view
      }
      else {
        throw GraphViewError.noStartNode
      }

      // Then draw next node when found an arrow and a node
      for index in 1..<flow.count {
        let e = flow[index]

        if let arrow = e as? Arrow {
          guard savedArrow == nil else { throw GraphViewError.danglingArrow }
          savedArrow = arrow
          continue
        }

        if let node = e as? Box {
          guard self.existingBoxView(with: node.id) == nil else { throw GraphViewError.duplicatedNodeId }
          guard let arrow = savedArrow else { throw GraphViewError.danglingNode }
          let nodeView = BoxView(box: node, config: node.config ?? graph.boxConfig)
          self.addBoxView(nodeView)

          let offset = EdgeOffsets.offset(from: savedNodeView.config.edgeOffsets,
                                          to: nodeView.config.edgeOffsets,
                                          direction: arrow.direction)
          constraints += savedNodeView.constraints(direction: arrow.direction,
                                                   to: nodeView,
                                                   offset: offset)

          let plan = ArrowDrawingPlan(startView: savedNodeView,
                                      endView: nodeView,
                                      arrow: arrow)
          arrowDrawingPlans.append(plan)

          savedNodeView = nodeView
          savedArrow = nil
        }
        else if let shortcut = e as? NodeShortcut {
          guard let arrow = savedArrow else { throw GraphViewError.danglingNode }
          guard let nodeView = self.existingBoxView(with: shortcut.id) else {
            throw GraphViewError.shortcutNodeNotFound
          }

          let plan = ArrowDrawingPlan(startView: savedNodeView,
                                      endView: nodeView,
                                      arrow: arrow)
          arrowDrawingPlans.append(plan)

          savedNodeView = nodeView
          savedArrow = nil
        }

      }
    }

    NSLayoutConstraint.activate(constraints)
    self.layoutIfNeeded()

    // --- arrows ---
    // We are not using autolayout for the arrows.
    // So need to add arrows this AFTER all canstraints are activated and laid out.
    for plan in arrowDrawingPlans {
      self.addArrow(plan, defaultConfig: graph.arrowConfig)
    }
  }

}

// Move boxes to correct places, so we can draw arrows using absolute coordinates.
PlaygroundPage.current.liveView = containerView
//PlaygroundPage.current.needsIndefiniteExecution = true

print("constraints: \(constraints.count)")
print(constraints.map{ $0.description }.joined(separator: "\n"))
print("")
print("graphView.subviews: \(graphView.subviews.count)")
print(graphView.subviews.map{ $0.description }.joined(separator: "\n"))

try graphView.draw(graph)

// --------------

public enum GraphViewError: Error {
  // Graph
  case graphIsEmpty
  // Node
  case duplicatedNodeId
  case noStartNode
  case danglingNode
  // NodeShortcut
  case shortcutNodeNotFound
  // Arrow
  case danglingArrow
}

public extension BoxView {
  convenience init(box: Box, config: BoxConfig) {
    self.init(Label(box.title), shape: box.shape, config: config)
    self.id = box.id
  }
}

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

public struct NodeShortcut: GraphElement, CustomStringConvertible {
  public let id: String

  public var description: String {
    return "[NodeShortcut id: \(id)]"
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
