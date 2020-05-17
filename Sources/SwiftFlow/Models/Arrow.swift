import UIKit

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
