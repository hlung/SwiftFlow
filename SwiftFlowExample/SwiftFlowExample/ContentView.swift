import SwiftUI
import SwiftFlow

// TODO: validate features
// TODO: add some tests
// TODO: remove unused code

struct ContentView: View {
  var body: some View {
    var blueNodeConfig = NodeConfig()
    blueNodeConfig.backgroundColor = UIColor(hex: "9EE5FF")

    var redNodeConfig = NodeConfig()
    redNodeConfig.backgroundColor = UIColor(hex: "FFCCD0")

    let graph = Graph()
    graph.nodeConfig = blueNodeConfig

//    graph.addFlow([
//      Node(.pill, title: "Start"),
//    ])

    graph.addFlow([
      Node(.pill, title: "Start"),
      Arrow(.down),
      Node(.diamond, title: "Work\nsuccess?", id: "success"),
      Arrow(.down, title: "Yes"),
      Node(.rect, title: "Go Party!"),
      Arrow(.down),
      Node(.pill, title: "End", id: "end"),
    ])

//    graph.addFlow([
//      NodeShortcut(id: "success"),
//      Arrow(.right, title: "No"),
//      Node(.rect, title: "Cry", config: redNodeConfig),
//      Arrow(.down),
//      Node(.rect, title: "Go home"),
//      Arrow(.down),
//      NodeShortcut(id: "end"),
//    ])

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

    try? graphView.draw(graph)

    return containerView
  }

  func updateUIView(_ uiView: UIView, context: Context) {
  }
}
