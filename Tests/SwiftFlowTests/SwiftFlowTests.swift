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
      Node("Cry", shape: .rect, id: "cry"), // different color using config
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
    try! graphView.render(graph)

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

  static var allTests = [
    ("testExample", testExample),
  ]
}
