import XCTest
@testable import SwiftFlow

final class SwiftFlowTests: XCTestCase {
  func testExample() {
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
      Node("Cry", shape: .rect), // different color using config
      Arrow(.down),
      Node("Go home", shape: .rect, id: "home"),
    ])

    graph.addFlow([
      NodeShortcut(id: "home"),
      ArrowLoopBack(from: .bottom, to: .right),
      NodeShortcut(id: "end")
    ])

    XCTAssertEqual(graph.flows.count, 3)
    XCTAssertEqual(graph.flows[0].count, 7)
    XCTAssertEqual(graph.flows[1].count, 5)
    XCTAssertEqual(graph.flows[2].count, 3)

    let graphView = GraphView()
    try! graphView.draw(graph)

    XCTAssertEqual(graphView.subviews.count, 8)
    XCTAssertNotNil(graphView.existingNodeView(with: "success"))
    XCTAssertNotNil(graphView.existingNodeView(with: "end"))
    XCTAssertNil(graphView.existingNodeView(with: "foo"))
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
