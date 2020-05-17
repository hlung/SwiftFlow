import UIKit

/// For chaining nodes together side-by-side. It has `direction` property for telling which way the arrow is pointing out from a node. You can also add annotations to it.
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

/// Similar to Arrow, but it also support drawing an **angled** arrow to go around existing nodes, typically for looping back to an existing node above. It can be used for linking further away nodes that would look nicer using an angled arrow than a straight one.
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
