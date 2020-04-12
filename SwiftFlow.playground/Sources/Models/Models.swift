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
  public var backgroundColor: UIColor
  public var borderColor: UIColor

  public static let `default` = BoxConfig(backgroundColor: .clear, borderColor: .black)
}
