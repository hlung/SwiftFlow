import UIKit

public class GraphView: UIView {
  public init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    setContentHuggingPriority(.required, for: .horizontal)
    setContentHuggingPriority(.required, for: .vertical)
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public extension GraphView {
  func existingBoxView(with id: String) -> BoxView? {
    return self.subviews.first(where: { view in
      if let view = view as? BoxView, view.id == id { return true }
      else { return false }
    }) as? BoxView
  }

  func addBoxView(_ boxView: BoxView) {
    super.addSubview(boxView)

    // Graph - Box constraints
    NSLayoutConstraint.activate([
      layoutMarginsGuide.topAnchor.constraint(lessThanOrEqualTo: boxView.topAnchor),
      layoutMarginsGuide.leftAnchor.constraint(lessThanOrEqualTo: boxView.leftAnchor),
      layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: boxView.bottomAnchor),
      layoutMarginsGuide.rightAnchor.constraint(greaterThanOrEqualTo: boxView.rightAnchor),
    ])
  }
}
