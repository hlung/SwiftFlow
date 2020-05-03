import SwiftUI
import SwiftFlow

// TODO: validate features
// TODO: add some tests
// TODO: remove unused code
// TODO: create demo gif

struct ContentView: View {
  var body: some View {

    let graph = Graph()

    var blueConfig = NodeConfig()
    blueConfig.backgroundColor = UIColor(hex: "CFF5FF")

    var redConfig = NodeConfig()
    redConfig.backgroundColor = UIColor(hex: "FFCCD0")

    graph.nodeConfig = blueConfig

    graph.addFlow([
      Node(.pill, title: "Start"),
      Arrow(.down),
      Node(.diamond, title: "Work\nsuccess?", id: "success"),
      Arrow(.down, title: "Yes"),
      Node(.rect, title: "Go Party!"),
      Arrow(),
      Node(.pill, title: "End", id: "end"),
    ])

    graph.addFlow([
      NodeShortcut(id: "success"),
      Arrow(.right, title: "No"),
      Node(.rect, title: "Cry", config: redConfig),
      Arrow(),
      Node(.rect, title: "Go home"),
      Arrow(),
      NodeShortcut(id: "end"),
    ])

    return GraphViewWrapper(graph: graph)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct GraphViewWrapper: UIViewRepresentable {
  var graph: Graph
  var containerView = UIView()
  var graphView = GraphView()

  func makeUIView(context: Context) -> UIView {
    containerView.backgroundColor = UIColor(hex: "EAEAEA")

    graphView.layoutMargins = UIEdgeInsets(shrinkingBy: 20)
    containerView.addSubview(graphView)
    var constraints: [NSLayoutConstraint] = []
    constraints += [
      graphView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      graphView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
    ]
    NSLayoutConstraint.activate(constraints)

    try! graphView.draw(graph)

    return containerView
  }

  func updateUIView(_ uiView: UIView, context: Context) {
  }
}
