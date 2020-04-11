/* TODO
 - add arrow label
 - add Box borders
 - change leading/trailing to left/right ?
 */

import UIKit
import PlaygroundSupport

// --- base model ---

public class Graph {
  var flows: [[GraphElement]] = []

  func addFlow(_ elements: [GraphElement]) {
    flows.append(elements)
  }
}

public protocol GraphElement {}

public struct Box: GraphElement, CustomStringConvertible {
  public let type: BoxType
  public let title: String
  public let id: String?
  public let uuid: String = UUID().uuidString

  public var description: String {
    return "[Box \(type) title: \(title) id: \(id ?? "-")]"
  }
}

public struct BoxExisting: GraphElement, CustomStringConvertible {
  let id: String

  public var description: String {
    return "[BoxExisting id: \(id)]"
  }
}

public struct Arrow: GraphElement, CustomStringConvertible {
  let direction: Direction
  let title: String?

  public var description: String {
    return "[Arrow \(direction) title \(title ?? "-")]"
  }
}

// --- UI preparation ---

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 400, height: 500))
containerView.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0)
let graphView = GraphView()
graphView.layoutMargins = UIEdgeInsets(shrinkingBy: 20)
graphView.subviewPadding = 20

var constraints: [NSLayoutConstraint] = []

containerView.addSubview(graphView)
constraints += [
  graphView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
  graphView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
]

// --- data ---
/*
 -----------------
 Legend:
 :: = id
 [], <> = box type
 v = arrow down
 -----------------

 [] Start
 v
 [] API Client receives responses
 v
 <> Success?
 > NO [] Handle failure :: result_no
 v YES [] Handle success :: result_yes
 v
 [] Print Yay
 result_no
 v
 [] Print Cry
 vv
 [] End

 */

let graph = Graph()

graph.addFlow([
  Box(type: .rect, title: "Start", id: nil),
  Arrow(direction: .down, title: nil),
  Box(type: .diamond, title: "Success?", id: "success"),
  Arrow(direction: .down, title: "Yes"),
  Box(type: .rect, title: "Celebrate", id: nil),
  Arrow(direction: .down, title: nil),
  Box(type: .rect, title: "End", id: "end"),
])

//graph.addFlow([
//  BoxExisting(id: "success"),
//  Arrow(direction: .right, title: "No"),
//  Box(type: .diamond, title: "Cry", id: nil),
//  Arrow(direction: .down, title: nil),
//  BoxExisting(id: "end"),
//])

// --- drawing ---

extension GraphView {
  public func boxView(with uuid: String) -> BoxView? {
    return self.subviews.first(where: { view in
//      print("boxView view", view)
//      print("boxView uuid", (view as? BoxView)?.uuid)
      if let view = view as? BoxView, view.uuid == uuid { return true }
      else { return false }
    }) as? BoxView
  }

  public func addSubviewIfNeeded(_ view: UIView) {
//    print("addSubviewIfNeeded view", view)
//    print("addSubviewIfNeeded subviews", self.subviews.first(where: { $0 == view }))
    guard (self.subviews.first(where: { $0 == view }) == nil) else { return }
    super.addSubview(view)
    view.layoutMargins = UIEdgeInsets(expandingBy: subviewPadding)
    NSLayoutConstraint.activate([
      topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
      leadingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
      trailingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
      bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
    ])
  }
}

var prevBox: Box?
var prevArrow: Arrow?
//var arrows: [(UIView, UIView)] = []
for flow in graph.flows {
  for index in 1..<flow.count {
    let e = flow[index]

    if let arrow = e as? Arrow, index+1 < flow.count {
      if let boxBefore = flow[index-1] as? Box, let boxAfter = flow[index+1] as? Box {

//        print(graphView.boxView(with: boxBefore.uuid))
        let boxBeforeView = graphView.boxView(with: boxBefore.uuid)
          ?? BoxView(Label(boxBefore.title), type: boxBefore.type)
        let boxAfterView = graphView.boxView(with: boxAfter.uuid)
          ?? BoxView(Label(boxAfter.title), type: boxAfter.type)

        boxBeforeView.uuid = boxBefore.uuid
        boxAfterView.uuid = boxAfter.uuid

        graphView.addSubviewIfNeeded(boxBeforeView)
        graphView.addSubviewIfNeeded(boxAfterView)
        constraints += boxBeforeView.constraints(direction: arrow.direction,
                                                 to: boxAfterView)

        print("-- \(boxBefore)\n   \(boxAfter)")
      }
    }
  }
}

//constraints += [
//  label_start,
//  label_api_call,
//  label_success,
//  label_yay,
//  label_end
//  ].constrainTopToBottom()

// Move boxes to correct places, so we can draw arrows using absolute coordinates.
PlaygroundPage.current.liveView = containerView
NSLayoutConstraint.activate(constraints)

print(graphView.subviews.map{ $0.description }.joined(separator: "\n"))

// We are not using autolayout for the arrows.
// So need to add arrows this AFTER all canstraints are activated and laid out.
//graphView.layoutIfNeeded()
//graphView.addArrow(direction: .down, on: [
//  label_start,
//  label_api_call,
//  label_success,
//  label_yay,
//  label_end
//])

//graphView.addArrow(direction: .right, on: [
//  label_success,
//  label_cry,
//])

// ---------

//PlaygroundPage.current.needsIndefiniteExecution = true
