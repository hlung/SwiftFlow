import UIKit

class Label: UILabel {
  public init(_ text: String) {
    super.init(frame: .zero)
    self.text = text
    self.textColor = .black
    self.backgroundColor = .clear
    self.numberOfLines = 0
    self.textAlignment = .center
    self.font = .systemFont(ofSize: 16)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.setContentCompressionResistancePriority(.required, for: .horizontal)
    self.setContentCompressionResistancePriority(.required, for: .vertical)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  public override var description: String {
    return "[Label frame = \(frame) \"\(text ?? "-")\"]"
  }
}
