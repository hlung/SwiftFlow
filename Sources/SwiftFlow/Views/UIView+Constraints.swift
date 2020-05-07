import UIKit

extension SFView {
  func constraints(direction: Direction, to view: SFView, offset: CGFloat = 0) -> [NSLayoutConstraint] {
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
