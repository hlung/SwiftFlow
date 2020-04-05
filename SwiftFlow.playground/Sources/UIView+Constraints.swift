import UIKit

public extension UIView {
  func trail(by view: UIView) -> [NSLayoutConstraint] {
    return [
      layoutMarginsGuide.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ]
  }

  func bottom(by view: UIView) -> [NSLayoutConstraint] {
    return [
      layoutMarginsGuide.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ]
  }
}

public extension Array where Element == UIView {
  func constrainTopToBottom() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    for (firstView, secondView) in allPairs {
      constraints += firstView.bottom(by: secondView)
    }
    return constraints
  }

  func constrainTrailingToLeading() -> [NSLayoutConstraint] {
    var constraints: [NSLayoutConstraint] = []
    for (firstView, secondView) in allPairs {
      constraints += firstView.trail(by: secondView)
    }
    return constraints
  }
}
