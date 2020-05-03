import UIKit

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
