import XCTest
@testable import SwiftFlow

final class SwiftFlowTests: XCTestCase {
  func testExample() {
    let graph = Graph()

    graph.addFlow([
      Node(.pill, title: "Start"),
      Arrow(.down),
      Node(.diamond, title: "Work\nsuccess?", id: "success"),
      Arrow(.down, title: "Yes"),
      Node(.rect, title: "Go Party!"),
      Arrow(.down),
      Node(.pill, title: "End", id: "end")
    ])

    graph.addFlow([
      NodeShortcut(id: "success"),
      Arrow(.right, title: "No"),
      Node(.rect, title: "Cry"),
      Arrow(.down),
      Node(.rect, title: "Go home"),
      Arrow(.down),
      NodeShortcut(id: "end")
    ])

    XCTAssertEqual(graph.flows.count, 2)
    XCTAssertEqual(graph.flows[0].count, 7)
    XCTAssertEqual(graph.flows[1].count, 7)

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
