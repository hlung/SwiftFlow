import UIKit

public struct NodeConfig {
  public var backgroundColor: UIColor = .clear
  public var borderColor: UIColor = .black
  /// Distance from the edges of other nodes
  public var edgeOffsets = EdgeOffsets(allSides: 20)

  public init() {}
}

public struct ArrowConfig {
  public var tailWidth: CGFloat = 2
  public var headWidth: CGFloat = 7
  public var headLength: CGFloat = 7
  public var startOffset: CGFloat = 20
  public var endOffset: CGFloat = 20
  public var color: UIColor = .black

  public init() {}
}
