import UIKit

public class Label: UILabel {

  public init(_ text: String) {
    super.init(frame: .zero)
    self.text = text
    self.textColor = .black
    self.backgroundColor = .lightGray
    self.font = .systemFont(ofSize: 18)
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
