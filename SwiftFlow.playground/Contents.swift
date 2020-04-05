// TODO: change leading/trailing to left/right
/* View hierarchy
 - containerView
  - graphView
   - boxes
   - arrows
 */
import UIKit
import PlaygroundSupport

var constraints: [NSLayoutConstraint] = []

// Customizables
let graphPadding: CGFloat = 20
let padding: CGFloat = 10

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 300, height: 300))
containerView.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0)
//containerView.translatesAutoresizingMaskIntoConstraints = false // don't do this!

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
constraints += [
  graphView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
  graphView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
]

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

// Box specific constraints
constraints += [
  label_start,
  label_api_call,
  label_success,
  label_yay,
  label_end
  ].constrainTopToBottom()

constraints += [
  //      label_cry,
  label_success,
  label_cry,
  ].constrainTrailingToLeading()

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

NSLayoutConstraint.activate(constraints)

// Move boxes to correct places, so we can draw arrows using absolute coordinates.
containerView.layoutIfNeeded()

graphView.addArrow(direction: .down, on: [
  label_start,
  label_api_call,
  label_success,
  label_yay,
  label_end
])

graphView.addArrow(direction: .right, on: [
  label_success,
  label_cry,
])

//PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = containerView
