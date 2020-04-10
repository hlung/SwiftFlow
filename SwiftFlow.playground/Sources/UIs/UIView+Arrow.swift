import UIKit

public enum ArrowDirection {
  case up
  case right
  case down
  case left
}

public extension UIView {
  func addArrow(direction: ArrowDirection, on views: [UIView]) {
    let parameters = ArrowParameters(tailWidth: 2, headWidth: 7, headLength: 7)
    for (firstView, secondView) in views.allPairs {
      let layer: CAShapeLayer
      switch direction {
      case .up:
        layer = CAShapeLayer.arrow(from: firstView.frame.centerTop,
                                   to:secondView.frame.centerBottom,
                                   parameters: parameters)
      case .right:
        layer = CAShapeLayer.arrow(from: firstView.frame.centerRight,
                                   to:secondView.frame.centerLeft,
                                   parameters: parameters)
      case .down:
        layer = CAShapeLayer.arrow(from: firstView.frame.centerBottom,
                                   to:secondView.frame.centerTop,
                                   parameters: parameters)
      case .left:
        layer = CAShapeLayer.arrow(from: firstView.frame.centerLeft,
                                   to:secondView.frame.centerRight,
                                   parameters: parameters)
      }
      self.layer.addSublayer(layer)
    }
  }
}
