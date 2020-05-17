import XCTest
@testable import SwiftFlow

final class SwiftFlowTests: XCTestCase {

  func test_drawing_normal_graph() {
    let graph = Graph()

    graph.addFlow([
      Node("Start", shape: .pill),
      Arrow(.down),
      Node("Work\nsuccess?", shape: .diamond, id: "success"), // declare id for later reference
      Arrow(.down, title: "Yes"),
      Node("Go Party!", shape: .rect, id: "party"),
      Arrow(.down),
      Node("End", shape: .pill, id: "end")
    ])

    graph.addFlow([
      NodeShortcut(id: "success"), // refers back to the Node above
      Arrow(.right, title: "No"), // branch out to the right side
      Node("Cry", shape: .rect, id: "cry"), // different color using config
      Arrow(.down),
      Node("Go home", shape: .rect, id: "home"),
    ])

    graph.addFlow([
      NodeShortcut(id: "home"),
      ArrowLoopBack(from: .bottom, to: .right),
      NodeShortcut(id: "end")
    ])

    // add empty flow should not affect the output
    graph.addFlow([
    ])

    XCTAssertEqual(graph.flows.count, 4)
    XCTAssertEqual(graph.flows[0].count, 7)
    XCTAssertEqual(graph.flows[1].count, 5)
    XCTAssertEqual(graph.flows[2].count, 3)

    let graphView = GraphView()
    try! graphView.draw(graph)

    XCTAssertEqual(graphView.subviews.count, 8)

    let successView = graphView.existingNodeView(with: "success")
    XCTAssertNotNil(successView)
    XCTAssertEqual(successView?.frame.integral, CGRect(x: 8, y: 77, width: 106, height: 106))

    let endView = graphView.existingNodeView(with: "end")
    XCTAssertNotNil(endView)
    XCTAssertEqual(endView?.frame.integral, CGRect(x: 37, y: 292, width: 48, height: 30))

    let cryView = graphView.existingNodeView(with: "cry")
    XCTAssertNotNil(cryView)
    XCTAssertEqual(cryView?.frame.integral, CGRect(x: 153.0, y: 115.0, width: 46.0, height: 30.0))

    let cryLabel = cryView?.subviews.first as? UILabel
    XCTAssertNotNil(cryLabel)
    XCTAssertEqual(cryLabel?.frame.integral, CGRect(x: 9.0, y: 5.0, width: 27.0, height: 20.0))
    XCTAssertEqual(cryLabel?.text, "Cry")

    let notExistingView = graphView.existingNodeView(with: "notExistingView")
    XCTAssertNil(notExistingView)
  }

  func test_drawing_graph_with_collision() {
    let graph = Graph()

    graph.addFlow([
      Node("Work\nsuccess?", shape: .diamond, id: "success"), // declare id for later reference
      Arrow(.down, title: "Yes"),
      Node("Go Party! Go Party! Go Party!", shape: .rect, id: "party"),
    ])

    graph.addFlow([
      NodeShortcut(id: "success"), // refers back to the Node above
      Arrow(.right, title: "No"), // branch out to the right side
      Node("Cry", shape: .rect, id: "cry"), // different color using config
      Arrow(.down),
      Node("Go home\nGo home", shape: .rect, id: "home"),
    ])

    XCTAssertEqual(graph.flows.count, 2)
    XCTAssertEqual(graph.flows[0].count, 3)
    XCTAssertEqual(graph.flows[1].count, 5)

    let graphView = GraphView()
    try! graphView.draw(graph)

    XCTAssertEqual(graphView.subviews.count, 6)

    let partyView = graphView.existingNodeView(with: "party")
    XCTAssertNotNil(partyView)
    XCTAssertEqual(partyView?.frame.integral, CGRect(x: 8.0, y: 164.0, width: 232.0, height: 30.0))

    let homeView = graphView.existingNodeView(with: "home")
    XCTAssertNotNil(homeView)
    XCTAssertEqual(homeView?.frame.integral, CGRect(x: 240.0, y: 115.0, width: 86.0, height: 49.0))
  }

  func test_drawing_dummy_node_graph() {
    let graph = Graph()

    graph.addFlow([
      Node("Start", shape: .pill, id: "start"),
      Arrow(.up),
    ])

    XCTAssertEqual(graph.flows.count, 1)
    XCTAssertEqual(graph.flows[0].count, 2)

    let graphView = GraphView()
    try! graphView.draw(graph)

    XCTAssertEqual(graphView.subviews.count, 2)

    let startView = graphView.existingNodeView(with: "start")
    XCTAssertNotNil(startView)
    XCTAssertEqual(startView?.frame.integral, CGRect(x: 7.0, y: 58.0, width: 57.0, height: 30.0))

    let dummyNodeView = graphView.subviews[1]
    XCTAssertNotNil(dummyNodeView)
    XCTAssertEqual(dummyNodeView.frame.integral, CGRect(x: 26.0, y: 8.0, width: 20.0, height: 10.0))
  }

  static var allTests = [
    ("test_drawing_normal_graph", test_drawing_normal_graph),
    ("test_drawing_graph_with_collision", test_drawing_graph_with_collision),
    ("test_drawing_dummy_node_graph", test_drawing_dummy_node_graph),
  ]

}
