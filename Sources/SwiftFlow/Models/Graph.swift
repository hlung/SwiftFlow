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

public struct ArrowLoopBack: GraphElement, CustomStringConvertible {
  public let direction: Direction
  public let title: String?
  public let config: ArrowConfig?

  public var description: String {
    return "[ArrowLoopBack \(direction) title \(title ?? "-")]"
  }

  public init(_ direction: Direction = .down,
              title: String? = nil,
              config: ArrowConfig? = nil) {
    self.direction = direction
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
