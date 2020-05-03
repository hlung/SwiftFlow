import UIKit

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

  public static func distance(from: EdgeOffsets, to: EdgeOffsets, direction: Direction) -> CGFloat {
    switch direction {
    case .up: return from.top + to.bottom
    case .left: return from.left + to.right
    case .down: return from.bottom + to.top
    case .right: return from.right + to.left
    }
  }
}

