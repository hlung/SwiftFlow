import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {

  let padding: CGFloat = 20

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray

    view.addSubview(stackViewMain)
    NSLayoutConstraint.activate([
      stackViewMain.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackViewMain.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])

    stackViewMain.addArrangedSubview(stackView1)
    stackViewMain.addArrangedSubview(stackView2)

    let label1_1 = Label("Hello")
    let label1_2 = Label("World")
    stackView1.addArrangedSubview(label1_1)
    stackView1.addArrangedSubview(label1_2)

    let label2_1 = Label("Hello")
    let label2_2 = Label("World")
    stackView2.addArrangedSubview(label2_1)
    stackView2.addArrangedSubview(label2_2)

    NSLayoutConstraint.activate([
      label1_2.centerYAnchor.constraint(equalTo: label2_1.centerYAnchor),
    ])

//    let v = UIView()
//    //    v.translatesAutoresizingMaskIntoConstraints = false
//    v.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//    v.backgroundColor = .red
//    stackView.addArrangedSubview(v)

//    print(view.bounds)

  }

  private lazy var stackView1: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .center
    view.spacing = padding
    view.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    view.isLayoutMarginsRelativeArrangement = true
    return view
  }()

  private lazy var stackView2: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .center
    view.spacing = padding
    view.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    view.isLayoutMarginsRelativeArrangement = true
    return view
  }()

  private lazy var stackViewMain: UIStackView = {
    let view = UIStackView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.alignment = .center
    view.spacing = padding
    view.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    view.isLayoutMarginsRelativeArrangement = true
    return view
  }()
}

let viewController = MyViewController()
viewController.preferredContentSize = CGSize(width: 600, height: 600)
PlaygroundPage.current.liveView = viewController
