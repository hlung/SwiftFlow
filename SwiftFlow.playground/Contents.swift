/* TODO
 - add arrow label
 - add Box borders
 - change leading/trailing to left/right ?
 */

import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 400, height: 500))
containerView.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0)
//containerView.translatesAutoresizingMaskIntoConstraints = false // don't add this
let graphView = GraphView()

// Customizables
graphView.layoutMargins = UIEdgeInsets(shrinkingBy: 20)
graphView.subviewPadding = 20

var constraints: [NSLayoutConstraint] = []
containerView.addSubview(graphView)
constraints += [
  graphView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
  graphView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
]

let label_start = BoxView(Label("Start"))
let label_api_call = BoxView(Label("API call"))
let label_success = BoxView(Label("API\nSuccess?"), type: .diamond)
let label_yay = BoxView(Label("Yay"))
//let label_cry = Box(Label("Cry"))
let label_end = BoxView(Label("End"))
graphView.addSubview(label_start)
graphView.addSubview(label_api_call)
graphView.addSubview(label_success)
graphView.addSubview(label_yay)
//graphView.addSubview(label_cry)
graphView.addSubview(label_end)

// Box specific constraints
//constraints += [
//  //      label_cry,
//  label_success,
//  label_cry,
//  ].constraintsByPuttingTrailingToLeading()

constraints += [
  label_start,
  label_api_call,
  label_success,
  label_yay,
  label_end
  ].constrainTopToBottom()

// Move boxes to correct places, so we can draw arrows using absolute coordinates.
PlaygroundPage.current.liveView = containerView
NSLayoutConstraint.activate(constraints)
graphView.layoutIfNeeded()

print("label_start", label_start.frame)
print("label_yay", label_yay.frame)

// We are not using autolayout for the arrows.
// So need to add arrows this AFTER all canstraints are activated and laid out.
graphView.addArrow(direction: .down, on: [
  label_start,
  label_api_call,
  label_success,
  label_yay,
  label_end
])

//graphView.addArrow(direction: .right, on: [
//  label_success,
//  label_cry,
//])

// ---------

//PlaygroundPage.current.needsIndefiniteExecution = true
