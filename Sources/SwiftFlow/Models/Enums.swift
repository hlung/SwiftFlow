import Foundation

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

  // aliases
  public static var top: Direction { .up }
  public static var bottom: Direction { .down }

  public var opposite: Direction {
    switch self {
    case .up: return .down
    case .left: return .right
    case .down: return .up
    case .right: return .left
    }
  }
}
