// TODO: change leading/trailing to left/right

import UIKit
import PlaygroundSupport

var constraints: [NSLayoutConstraint] = []

// Customizables
let graphInnerPadding: CGFloat = 20
let boxPadding: CGFloat = 20

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 400, height: 500))
containerView.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0)
//containerView.translatesAutoresizingMaskIntoConstraints = false // don't do this!

var graphView: UIView = {
  let view = UIView()
  view.translatesAutoresizingMaskIntoConstraints = false
  view.backgroundColor = .white
  view.layoutMargins = UIEdgeInsets(shrinkingBy: graphInnerPadding)
  view.setContentHuggingPriority(.required, for: .horizontal)
  view.setContentHuggingPriority(.required, for: .vertical)
  view.setContentCompressionResistancePriority(.required, for: .horizontal)
  view.setContentCompressionResistancePriority(.required, for: .vertical)
  return view
}()

containerView.addSubview(graphView)
constraints += [
  graphView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
  graphView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
]

let label_start = Box(Label("Start"))
let label_api_call = Box(Label("API call"))
let label_success = Box(Label("API\nSuccess?"), type: .diamond)
let label_yay = Label("Yay")
//let label_cry = Label("Cry")
let label_end = Label("End")
graphView.addSubview(label_start)
graphView.addSubview(label_api_call)
graphView.addSubview(label_success)
graphView.addSubview(label_yay)
//graphView.addSubview(label_cry)
graphView.addSubview(label_end)

// Box specific constraints
constraints += [
  label_start,
  label_api_call,
  label_success,
  label_yay,
  label_end
  ].constrainTopToBottom()

//constraints += [
//  //      label_cry,
//  label_success,
//  label_cry,
//  ].constraintsByPuttingTrailingToLeading()

// Box common constraints
for view in graphView.subviews {
  view.layoutMargins = UIEdgeInsets(expandingBy: boxPadding)
  constraints += view.constraintsByPuttingInside(graphView)
}

// Move boxes to correct places, so we can draw arrows using absolute coordinates.
containerView.layoutIfNeeded()

print("label_start", label_start.frame)
print("label_yay", label_yay.frame)

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

NSLayoutConstraint.activate(constraints)

//PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = containerView

print("Constraint is active: \(constraints.last?.isActive == true)")

public class Box: UIView {
  let subview: UIView
  let type: BoxType

  public enum BoxType {
    case rect
    case diamond
  }

  public init(_ view: UIView, type: BoxType = .rect) {
    self.subview = view
    self.type = type
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .gray
    self.addSubview(view)
    var constraints: [NSLayoutConstraint] = []

    switch type {
    case .rect:
      view.layoutMargins = UIEdgeInsets(expandingBy: 5)
      constraints += [
        topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
        leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
        trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
        bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
      ]
      NSLayoutConstraint.activate(constraints)

      self.layer.cornerRadius = 5
    case .diamond:
      view.layoutMargins = UIEdgeInsets(top: -view.intrinsicContentSize.width/2,
                                        left: -view.intrinsicContentSize.height/2,
                                        bottom: -view.intrinsicContentSize.width/2,
                                        right: -view.intrinsicContentSize.height/2)
      constraints += [
        topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
        leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
        trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
        bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
      ]
      NSLayoutConstraint.activate(constraints)
      self.layoutIfNeeded()

//      print("view.layoutMargins", view.layoutMargins)
//      print("view.frame", view.frame)
//      print("self.bounds", self.bounds)
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = UIBezierPath.diamond(self.bounds, inset: 0).cgPath
      self.layer.mask = shapeLayer
    }

//    self.layoutIfNeeded()
//
//    let shapeLayer = CAShapeLayer()
//    shapeLayer.path = UIBezierPath.diamond(self.bounds, inset: 0).cgPath
//    self.layer.mask = shapeLayer

//    print("view.bounds", view.bounds)
//    print("bounds", self.bounds)
  }

//  public override func draw(_ rect: CGRect) {
//    if self.type == .diamond {
//
//    }
//  }

  required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
}
