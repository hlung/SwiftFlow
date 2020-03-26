// TODO: change leading/trailing to left/right

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 300, height: 300))
containerView.backgroundColor = UIColor.lightGray
containerView.translatesAutoresizingMaskIntoConstraints = false
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = containerView

// Customizables
let graphPadding: CGFloat = 20
let padding: CGFloat = 10

var graphView: UIView = {
  let view = UIView()
  view.translatesAutoresizingMaskIntoConstraints = false
  view.backgroundColor = .white
  view.layoutMargins = UIEdgeInsets(top: graphPadding,
                                    left: graphPadding,
                                    bottom: graphPadding,
                                    right: graphPadding)
  view.setContentHuggingPriority(.required, for: .horizontal)
  view.setContentHuggingPriority(.required, for: .vertical)
  view.setContentCompressionResistancePriority(.required, for: .horizontal)
  view.setContentCompressionResistancePriority(.required, for: .vertical)
  return view
}()

containerView.addSubview(graphView)


let label_start = Label("Start")
graphView.addSubview(label_start)

var constraints: [NSLayoutConstraint] = []

// Box common constraints
for view in demoView.subviews {
  view.layoutMargins = UIEdgeInsets(top: -padding, left: -padding, bottom: -padding, right: -padding)
  constraints += [
    demoView.layoutMarginsGuide.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor),
    demoView.layoutMarginsGuide.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor),
    demoView.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor),
    demoView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor),
  ]
}

// Make this demoView in the Playground visible
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = demoView

// Open the Assitant Editor to see the result in the Playground
// --> View --> Assistant Editor --> Show Assistant Editor
// Create a layer object
//var layer = CALayer()
//
//// Set the properties
//layer.bounds = CGRect(x: 0, y: 0, width: 190, height: 190)
//layer.position = CGPoint(x: 300/2, y: 300/2)
//layer.backgroundColor = UIColor.white.cgColor
//layer.borderWidth = 3
//layer.borderColor = UIColor.black.cgColor
//
//// Add the layer
//demoView.layer.addSublayer(layer)

//public extension NSLayoutConstraint {
//  func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
//    self.priority = priority
//    return self
//  }
//}
//
//class MyViewController: UIViewController {
//
//  // Customizables
//  let graphPadding: CGFloat = 20
//  let padding: CGFloat = 10
//
//  private lazy var graphView: UIView = {
//    let view = UIView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.backgroundColor = .white
//    view.layoutMargins = UIEdgeInsets(top: graphPadding,
//                                      left: graphPadding,
//                                      bottom: graphPadding,
//                                      right: graphPadding)
//    view.setContentHuggingPriority(.required, for: .horizontal)
//    view.setContentHuggingPriority(.required, for: .vertical)
//    view.setContentCompressionResistancePriority(.required, for: .horizontal)
//    view.setContentCompressionResistancePriority(.required, for: .vertical)
//    return view
//  }()
//
//  override func loadView() {
//    view = ArrowView()
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    view.backgroundColor = .lightGray
//    view.addSubview(graphView)
//
//    var constraints: [NSLayoutConstraint] = []
//
//    let label_start = Label("Start")
//    let label_api_call = Label("API call")
//    let label_success = Label("Success?")
//    let label_yay = Label("Yay")
//    let label_cry = Label("Cry")
//    let label_end = Label("End")
//    graphView.addSubview(label_start)
//    graphView.addSubview(label_api_call)
//    graphView.addSubview(label_success)
//    graphView.addSubview(label_yay)
//    graphView.addSubview(label_cry)
//    graphView.addSubview(label_end)
//
//    // Graph constraints
//    constraints += [
//      graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//      graphView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//    ]
//
//    // Box common constraints
//    for view in graphView.subviews {
//      view.layoutMargins = UIEdgeInsets(top: -padding, left: -padding, bottom: -padding, right: -padding)
//      constraints += [
//        graphView.layoutMarginsGuide.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor),
//        graphView.layoutMarginsGuide.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor),
//        graphView.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor),
//        graphView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor),
//      ]
//    }
//
//    // Box specific constraints
//    constraints += [
//      label_start,
//      label_api_call,
//      label_success,
//      label_yay,
//      label_end
//      ].constrainTopToBottom()
//
//    constraints += [
////      label_cry,
//      label_success,
//      label_cry,
//      ].constrainTrailingToLeading()
//
//    NSLayoutConstraint.activate(constraints)
//    view.layoutIfNeeded()
//
//    //    print("graphView.frame: \(graphView.frame)")
//    //    print("firstBox.frame: \(firstBox.frame)")
//    //    print("secondBox.frame: \(secondBox.frame)")
//
////    let firstBox = label_cry
////    let secondBox = label_yay
//
////    let arrowLayer = createArrowLayer(from: firstBox.frame.bottom, to: secondBox.frame.top)
//    let arrowLayer = CAShapeLayer()
//    view.layer.addSublayer(arrowLayer)
//  }
//
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//
////    let arrowLayer = CAShapeLayer()
////    view.layer.addSublayer(arrowLayer)
//  }
//
//  func createArrowLayer(from: CGPoint, to: CGPoint) -> CAShapeLayer {
//    let parameters = ArrowParameters(tailWidth: 2, headWidth: 10, headLength: 10)
//    let path = UIBezierPath.arrow(from: from, to: to, parameters: parameters)
//    let layer = CAShapeLayer()
//    layer.path = path.cgPath
//    return layer
//  }
//
//  func printDebug(graphView: UIView, firstBox: UIView) {
//    print("graphView.frame: \(graphView.frame)")
//    print("firstBox.frame: \(firstBox.frame)")
//  }
//
//}
//
//let viewController = MyViewController()
//viewController.preferredContentSize = CGSize(width: 300, height: 500)
//PlaygroundPage.current.liveView = viewController
//
///* Designed syntax
//
//swiftflow
//  () Start
//  v
//  [] API Client receives responses
//  v
//  <> Success?
//  -YES-> Handle success :: result_yes, Direction.right
//  -NO-> Handle failure :: result_no
//
//  result_yes
//  v
//  [] Print Yay
//
//  result_no
//  v
//  [] Print Cry
//
//  vv
//  () End
//
//*/
