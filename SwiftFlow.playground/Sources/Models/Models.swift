import UIKit

public enum BoxShape {
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

public struct BoxConfig {
  public var backgroundColor: UIColor = .clear
  public var borderColor: UIColor = .black

  public init() {
  }
}

public struct ArrowConfig {
  public var tailWidth: CGFloat = 2
  public var headWidth: CGFloat = 7
  public var headLength: CGFloat = 7
  public var extraSpace: CGFloat = 0

  public init() {
  }
}
