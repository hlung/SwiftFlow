import UIKit

public class GraphView: UIView {
  public init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    setContentHuggingPriority(.required, for: .horizontal)
    setContentHuggingPriority(.required, for: .vertical)
    setContentCompressionResistancePriority(.required, for: .horizontal)
    setContentCompressionResistancePriority(.required, for: .vertical)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public extension GraphView {
  func existingNodeView(with id: String) -> NodeView? {
    return self.subviews.first(where: { view in
      if let view = view as? NodeView, view.id == id { return true }
      else { return false }
    }) as? NodeView
  }

  func addNodeView(_ nodeView: NodeView) {
    super.addSubview(nodeView)

    // Graph - Node constraints
    NSLayoutConstraint.activate([
      layoutMarginsGuide.topAnchor.constraint(lessThanOrEqualTo: nodeView.topAnchor),
      layoutMarginsGuide.leftAnchor.constraint(lessThanOrEqualTo: nodeView.leftAnchor),
      layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: nodeView.bottomAnchor),
      layoutMarginsGuide.rightAnchor.constraint(greaterThanOrEqualTo: nodeView.rightAnchor),
    ])
  }
}

public extension GraphView {

  func draw(_ graph: Graph) throws {

    var arrowDrawingPlans: [ArrowDrawingPlan] = []
    var constraints: [NSLayoutConstraint] = []

    for flow in graph.flows {
      guard !flow.isEmpty else { throw GraphViewError.graphIsEmpty }

      var savedNodeView: NodeView
      var savedArrow: Arrow? = nil

      // Draw first node
      if let firstNode = flow.first as? Node {
        let view = NodeView(node: firstNode, config: firstNode.config ?? graph.nodeConfig)
        self.addNodeView(view)
        savedNodeView = view
      }
      else if let firstShortcut = flow.first as? NodeShortcut {
        guard let view = self.existingNodeView(with: firstShortcut.id) else {
          throw GraphViewError.shortcutNodeNotFound
        }
        savedNodeView = view
      }
      else {
        throw GraphViewError.noStartNode
      }

      // Then draw next node when found an arrow and a node
      for index in 1..<flow.count {
        let e = flow[index]

        if let arrow = e as? Arrow {
          guard savedArrow == nil else { throw GraphViewError.danglingArrow }
          savedArrow = arrow
          continue
        }

        if let node = e as? Node {
          guard self.existingNodeView(with: node.id) == nil else { throw GraphViewError.duplicatedNodeId }
          guard let arrow = savedArrow else { throw GraphViewError.danglingNode }
          let nodeView = NodeView(node: node, config: node.config ?? graph.nodeConfig)
          self.addNodeView(nodeView)

          let offset = EdgeOffsets.offset(from: savedNodeView.config.edgeOffsets,
                                          to: nodeView.config.edgeOffsets,
                                          direction: arrow.direction)
          constraints += savedNodeView.constraints(direction: arrow.direction,
                                                   to: nodeView,
                                                   offset: offset)

          let plan = ArrowDrawingPlan(startView: savedNodeView,
                                      endView: nodeView,
                                      arrow: arrow)
          arrowDrawingPlans.append(plan)

          savedNodeView = nodeView
          savedArrow = nil
        }
        else if let shortcut = e as? NodeShortcut {
          guard let arrow = savedArrow else { throw GraphViewError.danglingNode }
          guard let nodeView = self.existingNodeView(with: shortcut.id) else {
            throw GraphViewError.shortcutNodeNotFound
          }

          let plan = ArrowDrawingPlan(startView: savedNodeView,
                                      endView: nodeView,
                                      arrow: arrow)
          arrowDrawingPlans.append(plan)

          savedNodeView = nodeView
          savedArrow = nil
        }

      }
    }

    NSLayoutConstraint.activate(constraints)
    self.layoutIfNeeded()

    // --- arrows ---
    // We are not using autolayout for the arrows.
    // So need to add arrows this AFTER all canstraints are activated and laid out.
    for plan in arrowDrawingPlans {
      self.addArrow(plan, defaultConfig: graph.arrowConfig)
    }
  }

}

public extension GraphView {
  func addArrow(_ plan: ArrowDrawingPlan, defaultConfig: ArrowConfig) {
    let config = plan.arrow.config ?? defaultConfig
    let startView: UIView = plan.startView
    let endView: UIView = plan.endView

    if let title = plan.arrow.title {
      let label = Label(title)
      label.font = .systemFont(ofSize: 14)
      addSubview(label)
      let spacing = config.tailWidth + 1
      let spacingFromBeginning: CGFloat = 2
      let labelConstraints: [NSLayoutConstraint]
      switch plan.arrow.direction {
      case .up:
        labelConstraints = [
          label.leftAnchor.constraint(equalTo: startView.centerXAnchor, constant: spacing),
          label.bottomAnchor.constraint(equalTo: startView.topAnchor, constant: -spacingFromBeginning),
        ]
      case .right:
        labelConstraints = [
          label.leftAnchor.constraint(equalTo: startView.rightAnchor, constant: spacingFromBeginning),
          label.bottomAnchor.constraint(equalTo: startView.centerYAnchor, constant: -spacing),
        ]
      case .down:
        labelConstraints = [
          label.leftAnchor.constraint(equalTo: startView.centerXAnchor, constant: spacing),
          label.topAnchor.constraint(equalTo: startView.bottomAnchor, constant: spacingFromBeginning),
        ]
      case .left:
        labelConstraints = [
          label.rightAnchor.constraint(equalTo: startView.leftAnchor, constant: -spacingFromBeginning),
          label.bottomAnchor.constraint(equalTo: startView.centerYAnchor, constant: -spacing),
        ]
      }
      NSLayoutConstraint.activate(labelConstraints)
    }

    let layer: CAShapeLayer
    switch plan.arrow.direction {
    case .up:
      layer = CAShapeLayer.arrow(from: startView.frame.centerTop,
                                 to: endView.frame.centerBottom,
                                 config: config)
    case .right:
      layer = CAShapeLayer.arrow(from: startView.frame.centerRight,
                                 to: endView.frame.centerLeft,
                                 config: config)
    case .down:
      layer = CAShapeLayer.arrow(from: startView.frame.centerBottom,
                                 to: endView.frame.centerTop,
                                 config: config)
    case .left:
      layer = CAShapeLayer.arrow(from: startView.frame.centerLeft,
                                 to: endView.frame.centerRight,
                                 config: config)
    }
    self.layer.addSublayer(layer)
  }
}

public enum GraphViewError: Error {
  // Graph
  case graphIsEmpty
  // Node
  case duplicatedNodeId
  case noStartNode
  case danglingNode
  // NodeShortcut
  case shortcutNodeNotFound
  // Arrow
  case danglingArrow
}
