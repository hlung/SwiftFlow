import UIKit

public extension UIView {
  func constraints(direction: Direction, to view: UIView, offset: CGFloat = 0) -> [NSLayoutConstraint] {
    switch direction {
    case .up:
      return [
        topAnchor.constraint(equalTo: view.bottomAnchor, constant: offset),
        centerXAnchor.constraint(equalTo: view.centerXAnchor),
      ]
    case .left:
      return [
        leftAnchor.constraint(equalTo: view.rightAnchor, constant: offset),
        centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ]
    case .down:
      return [
        bottomAnchor.constraint(equalTo: view.topAnchor, constant: -offset),
        centerXAnchor.constraint(equalTo: view.centerXAnchor),
      ]
    case .right:
      return [
        rightAnchor.constraint(equalTo: view.leftAnchor, constant: -offset),
        centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ]
    }
  }
}

//public extension UIView {
//  func constraintsByPuttingTrailing(_ view: UIView) -> [NSLayoutConstraint] {
//    return [
//      layoutMarginsGuide.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//      centerYAnchor.constraint(equalTo: view.centerYAnchor),
//    ]
//  }
//
//  func constraintsByPuttingBelow(_ view: UIView) -> [NSLayoutConstraint] {
//    return [
//      layoutMarginsGuide.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//      centerXAnchor.constraint(equalTo: view.centerXAnchor),
//    ]
//  }
//
////  func constraintsByPuttingInside(_ view: UIView) -> [NSLayoutConstraint] {
////    return [
////      view.topAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.topAnchor),
////      view.leadingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
////      view.trailingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
////      view.bottomAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
//////      layoutMarginsGuide.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor),
//////      layoutMarginsGuide.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor),
//////      layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor),
//////      layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor),
////    ]
////  }
//}

//public extension Array where Element == UIView {
//  func constrainTopToBottom() -> [NSLayoutConstraint] {
//    var constraints: [NSLayoutConstraint] = []
//    for (firstView, secondView) in allPairs {
//      constraints += firstView.constraintsByPuttingBelow(secondView)
//    }
//    return constraints
//  }
//
//  func constraintsByPuttingTrailingToLeading() -> [NSLayoutConstraint] {
//    var constraints: [NSLayoutConstraint] = []
//    for (firstView, secondView) in allPairs {
//      constraints += firstView.constraintsByPuttingTrailing(secondView)
//    }
//    return constraints
//  }
//}

public extension UIEdgeInsets {
  init(expandingBy value: CGFloat) {
    self.init(top: -value, left: -value, bottom: -value, right: -value)
  }

  init(shrinkingBy value: CGFloat) {
    self.init(top: value, left: value, bottom: value, right: value)
  }
}

public extension NSLayoutConstraint {
  func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }
}
