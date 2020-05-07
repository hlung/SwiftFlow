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

struct DummyNode: GraphElement {}

public struct Node: GraphElement, CustomStringConvertible {
  public let title: String
  public let shape: NodeShape
  public let id: String
  public let config: NodeConfig?

  public var description: String {
    return "[Node \"\(title)\" shape: \(shape) id: \(id)]"
  }

  public init(_ title: String,
              shape: NodeShape = .rect,
              id: String = UUID().uuidString,
              config: NodeConfig? = nil) {
    self.title = title
    self.shape = shape
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

public protocol ArrowProviding {
  var direction: Direction { get }
  var title: String? { get }
  var config: ArrowConfig? { get }
}

public struct Arrow: GraphElement, ArrowProviding, CustomStringConvertible {
  /// The direction to add the next node
  public let direction: Direction
  public let title: String?
  public let config: ArrowConfig?

  public var description: String {
    return "[Arrow \"\(title ?? "-")\" \(direction)]"
  }

  public init(_ direction: Direction = .down,
              title: String? = nil,
              config: ArrowConfig? = nil) {
    self.direction = direction
    self.title = title
    self.config = config
  }
}

public struct ArrowLoopBack: GraphElement, ArrowProviding, CustomStringConvertible {
  /// The side of start node which arrow will start
  public let direction: Direction
  /// The side of end node which arrow will end
  public let endDirection: Direction
  public let title: String?
  public let config: ArrowConfig?

  public var description: String {
    return "[ArrowLoopBack \"\(title ?? "-")\" \(direction) to \(endDirection)]"
  }

  public init(from direction: Direction,
              to endDirection: Direction,
              title: String? = nil,
              config: ArrowConfig? = nil) {
    self.direction = direction
    self.endDirection = endDirection
    self.title = title
    self.config = config
  }
}

public struct Line {
  public let from: CGPoint
  public let to: CGPoint

  public init(_ from: CGPoint, _ to: CGPoint) {
    self.from = from
    self.to = to
  }
}
