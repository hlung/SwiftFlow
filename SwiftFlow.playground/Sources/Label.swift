import UIKit

public class Label: UILabel {
  public init(_ text: String) {
//    super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    super.init(frame: .zero)
    self.text = text
    self.textColor = .black
    self.backgroundColor = .gray
//    self.textAlignment = .center
//    print("label!")
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
