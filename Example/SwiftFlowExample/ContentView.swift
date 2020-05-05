import SwiftUI
import SwiftFlow

struct ContentView: View {
  var body: some View {

    let graph = Graph()

    var blueConfig = NodeConfig()
    blueConfig.backgroundColor = UIColor(red: 0.81, green: 0.96, blue: 1.00, alpha: 1.00)

    var redConfig = NodeConfig()
    redConfig.backgroundColor = UIColor(red: 1.00, green: 0.80, blue: 0.82, alpha: 1.00)

    graph.nodeConfig = blueConfig

    graph.addFlow([
      Node(.pill, title: "Start"),
      Arrow(.down),
      Node(.diamond, title: "Work\nsuccess?", id: "success"), // declare id for later reference
      Arrow(.down, title: "Yes"),
      Node(.rect, title: "Go Party!", id: "party"),
      Arrow(.down),
      Node(.pill, title: "End", id: "end")
    ])

    graph.addFlow([
      NodeShortcut(id: "success"), // refers back to the Node above
      Arrow(.right, title: "No"),
      Node(.rect, title: "Cry", config: redConfig),
      Arrow(.down),
      Node(.rect, title: "Go home"),
      Arrow(.down),
      NodeShortcut(id: "end")
    ])

    graph.addFlow([
      NodeShortcut(id: "party"), // refers back to the Node above
      ArrowLoopBack(.left),
      NodeShortcut(id: "success")
    ])

    let graphView = GraphView()
    graphView.layoutMargins = UIEdgeInsets(top: 20, left: 50, bottom: 20, right: 50)
    try! graphView.draw(graph)

    return UIViewCenteringWrapper(contentView: graphView)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

private struct UIViewCenteringWrapper: UIViewRepresentable {
  let contentView: UIView
  let containerView = UIView()

  func makeUIView(context: Context) -> UIView {
    containerView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00) // #EAEAEA

    containerView.addSubview(contentView)
    var constraints: [NSLayoutConstraint] = []
    constraints += [
      contentView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      contentView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
    ]
    NSLayoutConstraint.activate(constraints)

    return containerView
  }

  func updateUIView(_ uiView: UIView, context: Context) {
  }
}
