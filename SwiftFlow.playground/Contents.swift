import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray

    var constraints: [NSLayoutConstraint] = []

    view.addSubview(graphView)
    NSLayoutConstraint.activate([
      graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      graphView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])

//    let firstColumnViews: [UIView] = [
//      Label("Hello"),
//      Label("World"),
//      Label("!!!")
//    ]
//
//    for view in firstColumnViews {
//      graphView.addSubview(view)
//    }

    let label1_1 = Label("Hello")
    let label1_2 = Label("World")
    let label1_3 = Label("!!!")
    graphView.addSubview(label1_1)
    graphView.addSubview(label1_2)
    graphView.addSubview(label1_3)

    // Set up constraints for links
    constraints.append(contentsOf: [
      label1_1.bottomAnchor.constraint(lessThanOrEqualTo: label1_2.topAnchor, constant: -padding),
      label1_1.centerXAnchor.constraint(equalTo: label1_2.centerXAnchor),

      label1_2.bottomAnchor.constraint(lessThanOrEqualTo: label1_3.topAnchor, constant: -padding),
      label1_2.centerXAnchor.constraint(equalTo: label1_3.centerXAnchor),
    ])

    // Set up constraints for all boxes
    for view in graphView.subviews {
      let array: [NSLayoutConstraint] = [
        graphView.layoutMarginsGuide.topAnchor
          .constraint(lessThanOrEqualTo: view.topAnchor),
        graphView.layoutMarginsGuide.leadingAnchor
          .constraint(lessThanOrEqualTo: view.leadingAnchor),
        graphView.layoutMarginsGuide.trailingAnchor
          .constraint(greaterThanOrEqualTo: view.trailingAnchor),
        graphView.layoutMarginsGuide.bottomAnchor
          .constraint(greaterThanOrEqualTo: view.bottomAnchor),
      ]
      constraints.append(contentsOf: array)
    }

    NSLayoutConstraint.activate(constraints)

//    let label2_1 = Label("Hello")
//    let label2_2 = Label("World")

//    NSLayoutConstraint.activate([
//      graphView.topAnchor.constraint(equalTo: label1_1.topAnchor),
//      label1_1.bottomAnchor.constraint(equalTo: graphView.bottomAnchor),
//      graphView.leadingAnchor.constraint(equalTo: label1_1.leadingAnchor),
//      label1_1.trailingAnchor.constraint(equalTo: graphView.trailingAnchor),
//    ])

//    print(label1_1.frame)
//    view.layoutIfNeeded()
//    print(label1_1.frame)

//    graphView.widthAnchor.constraint(equalToConstant: 200).isActive = true

//    NSLayoutConstraint.activate([
//      graphView.layoutMarginsGuide.topAnchor.constraint(equalTo: label1_1.topAnchor),
//      label1_1.bottomAnchor.constraint(equalTo: label1_2.topAnchor),
////      graphView.leadingAnchor.constraint(equalTo: label1_1.leadingAnchor),
////      label1_1.trailingAnchor.constraint(equalTo: graphView.layoutMarginsGuide.trailingAnchor),
//    ])
//
//    graphView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: label1_1.leadingAnchor)
//      .isActive = true
//    graphView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: label1_1.trailingAnchor)
//      .isActive = true
//    graphView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: label1_2.bottomAnchor)
//      .isActive = true
//
//    for view in graphView.subviews {
//      graphView.layoutMarginsGuide.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor).isActive = true
//      view.trailingAnchor.constraint(greaterThanOrEqualTo: graphView.layoutMarginsGuide.trailingAnchor).isActive = true
//      graphView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor).isActive = true
//    }
  }

  let padding: CGFloat = 10

  private lazy var graphView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    view.setContentHuggingPriority(.required, for: .horizontal)
    view.setContentHuggingPriority(.required, for: .vertical)
    view.setContentCompressionResistancePriority(.required, for: .horizontal)
    view.setContentCompressionResistancePriority(.required, for: .vertical)
    return view
  }()

}

let viewController = MyViewController()
viewController.preferredContentSize = CGSize(width: 300, height: 500)
PlaygroundPage.current.liveView = viewController

/* Designed syntax

swiftflow
  () Start
  v
  [] API Client receives responses
  v
  <> Success?
  -YES-> Handle success :: result_yes, Direction.right
  -NO-> Handle failure :: result_no

  result_yes
  v
  [] Print Yay

  result_no
  v
  [] Print Cry

  vv
  () End

*/
