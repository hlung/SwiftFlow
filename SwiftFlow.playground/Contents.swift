import UIKit
import PlaygroundSupport

class MyViewController: UIViewController {

  // -------------
  // Customizables
  // -------------
  let graphPadding: CGFloat = 20
  let padding: CGFloat = 10
  // -------------

  private lazy var graphView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.layoutMargins = UIEdgeInsets(top: graphPadding, left: graphPadding, bottom: graphPadding, right: graphPadding)
    view.setContentHuggingPriority(.required, for: .horizontal)
    view.setContentHuggingPriority(.required, for: .vertical)
    view.setContentCompressionResistancePriority(.required, for: .horizontal)
    view.setContentCompressionResistancePriority(.required, for: .vertical)
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray
    view.addSubview(graphView)

    var constraints: [NSLayoutConstraint] = []

    let label_start = Label("Start")
    let label_api_call = Label("API call")
    let label_success = Label("Success?")
    let label_yay = Label("Yay")
    let label_cry = Label("Cry")
    let label_end = Label("End")
    graphView.addSubview(label_start)
    graphView.addSubview(label_api_call)
    graphView.addSubview(label_success)
    graphView.addSubview(label_yay)
    graphView.addSubview(label_cry)
    graphView.addSubview(label_end)

    // Graph constraints
    constraints += [
      graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      graphView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ]

    // Box common constraints
    for view in graphView.subviews {
      view.layoutMargins = UIEdgeInsets(top: -padding, left: -padding, bottom: -padding, right: -padding)
      constraints += [
        graphView.layoutMarginsGuide.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor),
        graphView.layoutMarginsGuide.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor),
        graphView.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor),
        graphView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor),
      ]
    }

    // Box specific constraints
    constraints += [
      label_start,
      label_api_call,
      label_success,
      label_yay,
      label_end
      ].constrainTopToBottom()

    constraints += [
      label_success,
      label_cry
      ].constrainTrailingToLeading()

    NSLayoutConstraint.activate(constraints)
  }

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
