import UIKit

public class GraphView: UIView {
  public var subviewPadding: CGFloat = 20

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

  public override func addSubview(_ view: UIView) {
    super.addSubview(view)
    view.layoutMargins = UIEdgeInsets(expandingBy: subviewPadding)
    NSLayoutConstraint.activate([
      topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
      leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
      trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
      bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
    ])
  }

}
