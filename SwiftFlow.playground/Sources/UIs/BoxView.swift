import UIKit

public class BoxView: UIView {
  let view: UIView
  let type: BoxType

  public enum BoxType {
    case rect
    case diamond
  }

  // Customizables
  private let rectLayoutMargins = UIEdgeInsets(top: -10,
                                               left: -20,
                                               bottom: -10,
                                               right: -20)
  private let rectCornerRadius: CGFloat = 5

  public init(_ view: UIView, type: BoxType = .rect) {
    self.view = view
    self.type = type
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .gray
    self.setContentHuggingPriority(.required, for: .horizontal)
    self.setContentHuggingPriority(.required, for: .vertical)
    self.addSubview(view)
    var constraints: [NSLayoutConstraint] = []

    constraints += [
      centerXAnchor.constraint(equalTo: view.centerXAnchor),
      centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ]

    switch type {
    case .rect:
      view.layoutMargins = rectLayoutMargins
      constraints += [
        topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
        leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
        trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
        bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
      ]
      NSLayoutConstraint.activate(constraints)

      self.layer.cornerRadius = rectCornerRadius
    case .diamond:
      view.layoutMargins = UIEdgeInsets(top: -view.intrinsicContentSize.width/2,
                                        left: -view.intrinsicContentSize.height/2,
                                        bottom: -view.intrinsicContentSize.width/2,
                                        right: -view.intrinsicContentSize.height/2)
      constraints += [
        topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
        leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
        trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
        bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
      ]
      NSLayoutConstraint.activate(constraints)
      self.layoutIfNeeded()

      let shapeLayer = CAShapeLayer()
      shapeLayer.path = UIBezierPath.diamond(self.bounds, inset: 0).cgPath
      self.layer.mask = shapeLayer
    }
  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
}
