import UIKit

extension CGPoint {
  func offset(_ direction: Direction, for offset: CGFloat) -> CGPoint {
    switch direction {
    case .up: return CGPoint(x: x, y: y - offset)
    case .right: return CGPoint(x: x + offset, y: y)
    case .down: return CGPoint(x: x, y: y + offset)
    case .left: return CGPoint(x: x - offset, y: y)
    }
  }

  static func align(_ p1: inout CGPoint, _ p2: inout CGPoint, _ direction: Direction) {
    switch direction {
    case .up:     p1.y = min(p1.x, p2.x); p2.y = min(p1.x, p2.x)
    case .left:   p1.x = min(p1.x, p2.x); p2.x = min(p1.x, p2.x)
    case .down:   p1.y = max(p1.x, p2.x); p2.y = max(p1.x, p2.x)
    case .right:  p1.x = max(p1.x, p2.x); p2.x = max(p1.x, p2.x)
    }
  }
}

extension CGRect {
  var centerBottom: CGPoint { CGPoint(x: midX, y: maxY) }
  var centerTop: CGPoint { CGPoint(x: midX, y: minY) }
  var centerLeft: CGPoint { CGPoint(x: minX, y: midY) }
  var centerRight: CGPoint { CGPoint(x: maxX, y: midY) }

  func centerPoint(in direction: Direction) -> CGPoint {
    switch direction {
    case .up: return centerTop
    case .left: return centerLeft
    case .down: return centerBottom
    case .right: return centerRight
    }
  }
}

extension UIView {
  func constraints(direction: Direction, to view: UIView, offset: CGFloat = 0) -> [NSLayoutConstraint] {
    switch direction {
    case .up:
      return [
        topAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: offset),
        centerXAnchor.constraint(equalTo: view.centerXAnchor),
      ]
    case .left:
      return [
        leftAnchor.constraint(greaterThanOrEqualTo: view.rightAnchor, constant: offset),
        centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ]
    case .down:
      return [
        bottomAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: -offset),
        centerXAnchor.constraint(equalTo: view.centerXAnchor),
      ]
    case .right:
      return [
        rightAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: -offset),
        centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ]
    }
  }
}

extension NSLayoutConstraint {
  func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }
}
