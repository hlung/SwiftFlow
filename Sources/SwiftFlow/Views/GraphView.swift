import UIKit

public class GraphView: SFView {
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

  func addView(_ nodeView: SFView) {
    super.addSubview(nodeView)

    // Graph - Node constraints
    NSLayoutConstraint.activate([
      layoutMarginsGuide.topAnchor.constraint(lessThanOrEqualTo: nodeView.topAnchor),
      layoutMarginsGuide.leftAnchor.constraint(lessThanOrEqualTo: nodeView.leftAnchor),
      layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: nodeView.bottomAnchor),
      layoutMarginsGuide.rightAnchor.constraint(greaterThanOrEqualTo: nodeView.rightAnchor),
    ])
  }
}

extension GraphView {
  func existingNodeView(with id: String) -> NodeView? {
    return self.subviews.first(where: { view in
      if let view = view as? NodeView, view.id == id { return true }
      else { return false }
    }) as? NodeView
  }
}
