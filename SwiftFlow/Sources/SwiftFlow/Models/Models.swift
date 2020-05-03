import UIKit

public class Graph {
  public var flows: [[GraphElement]] = []
  public var nodeConfig = NodeConfig()
  public var arrowConfig = ArrowConfig()

  public init(nodeConfig: NodeConfig = NodeConfig(), arrowConfig: ArrowConfig = ArrowConfig(), flows: [[GraphElement]] = []) {
    self.flows = flows
    self.nodeConfig = nodeConfig
    self.arrowConfig = arrowConfig
  }

  public func addFlow(_ elements: [GraphElement]) {
    flows.append(elements)
  }
}

public protocol GraphElement {}

public struct DummyNode: GraphElement {}

public struct Node: GraphElement, CustomStringConvertible {
  public let shape: NodeShape
  public let title: String
  public let id: String
  public let config: NodeConfig?

  public var description: String {
    return "[Node \(shape) title: \(title) id: \(id)]"
  }

  public init(_ shape: NodeShape,
              title: String,
              id: String = UUID().uuidString,
              config: NodeConfig? = nil) {
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

  public init(id: String) {
    self.id = id
  }
}

public struct Arrow: GraphElement, CustomStringConvertible {
  public let direction: Direction
  public let title: String?
  public let config: ArrowConfig?

  public var description: String {
    return "[Arrow \(direction) title \(title ?? "-")]"
  }

  public init(_ direction: Direction = .down,
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

public enum NodeShape {
  case rect
  case pill
  case diamond
}

public enum Direction {
  case up
  case left
  case down
  case right
}

public struct EdgeOffsets {
  public let top: CGFloat
  public let left: CGFloat
  public let bottom: CGFloat
  public let right: CGFloat

  public init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  public init(allSides value: CGFloat) {
    self.top = value
    self.left = value
    self.bottom = value
    self.right = value
  }

  public static func offset(from: EdgeOffsets, to: EdgeOffsets, direction: Direction) -> CGFloat {
    switch direction {
    case .up: return from.top + to.bottom
    case .left: return from.left + to.right
    case .down: return from.bottom + to.top
    case .right: return from.right + to.left
    }
  }
}

public struct NodeConfig {
  public var backgroundColor: UIColor = .clear
  public var borderColor: UIColor = .black
  public var edgeOffsets = EdgeOffsets(allSides: 20)

  public init() {}
}

public struct ArrowConfig {
  public var tailWidth: CGFloat = 2
  public var headWidth: CGFloat = 7
  public var headLength: CGFloat = 7

  public init() {}
}
