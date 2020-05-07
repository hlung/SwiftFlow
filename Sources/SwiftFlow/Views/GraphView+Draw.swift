import UIKit

public enum GraphDrawError: Error {
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
  case danglingArrowLoopBack
}

public extension GraphView {

  func draw(_ graph: Graph) throws {
    var arrowDrawingPlans: [ArrowDrawingPlan] = []
    var constraints: [NSLayoutConstraint] = []

    for flow in graph.flows {
      guard !flow.isEmpty else { throw GraphDrawError.graphIsEmpty }

      var flow = flow
      var savedNodeView: NodeView
      var savedArrow: ArrowProviding? = nil

      // Draw first node
      if let firstNode = flow.first as? Node {
        let view = NodeView(node: firstNode, config: firstNode.config ?? graph.nodeConfig)
        self.addView(view)
        savedNodeView = view
      }
      else if let firstShortcut = flow.first as? NodeShortcut {
        guard let view = self.existingNodeView(with: firstShortcut.id) else {
          throw GraphDrawError.shortcutNodeNotFound
        }
        savedNodeView = view
      }
      else {
        throw GraphDrawError.noStartNode
      }

      // If last element is an arrow, add a dummy node to allow drawing last dangling arrow.
      if let _ = flow.last as? Arrow {
        let dummyNode = DummyNode()
        flow.append(dummyNode)
      }

      // Then draw next node when found an arrow and a node
      for index in 1..<flow.count {
        let e = flow[index]

        if let arrow = e as? ArrowProviding {
          if savedArrow != nil { throw GraphDrawError.danglingArrow }
          savedArrow = arrow
        }
        else if let node = e as? Node {
          if self.existingNodeView(with: node.id) != nil { throw GraphDrawError.duplicatedNodeId }
          guard let arrow = savedArrow else { throw GraphDrawError.danglingNode }
          let nodeView = NodeView(node: node, config: node.config ?? graph.nodeConfig)
          self.addView(nodeView)

          let offset = EdgeOffsets.distance(from: savedNodeView.config.edgeOffsets,
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
          guard let nodeView = self.existingNodeView(with: shortcut.id) else {
            throw GraphDrawError.shortcutNodeNotFound
          }

          if let arrow = savedArrow {
            let plan = ArrowDrawingPlan(startView: savedNodeView,
                                        endView: nodeView,
                                        arrow: arrow)
            arrowDrawingPlans.append(plan)

            savedNodeView = nodeView
            savedArrow = nil
          }
        }
        else if e is DummyNode, let arrow = savedArrow {
          let nodeView = NodeView(node: Node(.pill, title: ""), config: NodeConfig())
          nodeView.isHidden = true
          self.addView(nodeView)

          let offset = EdgeOffsets.distance(from: savedNodeView.config.edgeOffsets,
                                            to: nodeView.config.edgeOffsets,
                                            direction: arrow.direction)
          constraints += savedNodeView.constraints(direction: arrow.direction,
                                                   to: nodeView,
                                                   offset: offset)

          let plan = ArrowDrawingPlan(startView: savedNodeView,
                                      endView: nodeView,
                                      arrow: arrow)
          arrowDrawingPlans.append(plan)
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

  private func addArrow(_ plan: ArrowDrawingPlan, defaultConfig: ArrowConfig) {
    let config = plan.arrow.config ?? defaultConfig
    let startView: UIView = plan.startView
    let endView: UIView = plan.endView

    addLabel(with: plan, config: config, startView: startView)

    if let arrow = plan.arrow as? Arrow {
      // Draw arrow
      let line = createLine(between: startView, and: endView, in: arrow.direction)
      let arrowLayer = CAShapeLayer()
      let path = UIBezierPath.arrow(line: line, config: config)
      arrowLayer.path = path.cgPath
      arrowLayer.fillColor = config.color.cgColor
      self.layer.addSublayer(arrowLayer)
    }
    else if let arrow = plan.arrow as? ArrowLoopBack {
      let p1 = startView.frame.centerPoint(in: arrow.direction)
      let p4 = endView.frame.centerPoint(in: arrow.endDirection)

      var p2 = p1.offset(arrow.direction, for: config.startOffset)
      var p3 = p4.offset(arrow.endDirection, for: config.endOffset)

      if arrow.direction == arrow.endDirection {
        alignPoints(&p2, &p3, arrow.direction)
      }

      // Add line to start of arrow, in another layer.
      // Because the arrow drawing code I found doesn't use strokeColor :/
      let lineLayer = CAShapeLayer()
      let linePath = UIBezierPath()
      linePath.move(to: p1)
      linePath.addLine(to: p2)
      linePath.addLine(to: p3)
      lineLayer.path = linePath.cgPath
      lineLayer.lineWidth = config.tailWidth
      lineLayer.strokeColor = config.color.cgColor
      lineLayer.fillColor = nil
      lineLayer.opacity = 1.0
      self.layer.addSublayer(lineLayer)

      // Draw final straight arrow to the end
      let arrowLayer = CAShapeLayer()
      let path = UIBezierPath.arrow(line: Line(p3, p4), config: config)
      arrowLayer.path = path.cgPath
      arrowLayer.fillColor = config.color.cgColor
      self.layer.addSublayer(arrowLayer)
    }
  }

  private func alignPoints(_ p1: inout CGPoint, _ p2: inout CGPoint, _ direction: Direction) {
    switch direction {
    case .up:     p1.y = min(p1.x, p2.x); p2.y = min(p1.x, p2.x)
    case .left:   p1.x = min(p1.x, p2.x); p2.x = min(p1.x, p2.x)
    case .down:   p1.y = max(p1.x, p2.x); p2.y = max(p1.x, p2.x)
    case .right:  p1.x = max(p1.x, p2.x); p2.x = max(p1.x, p2.x)
    }
  }

  // Example:
  // Direction.right = [startView] -> [endView]
  // Direction.left  = [startView] <- [endView]
  private func createLine(between startView: UIView, and endView: UIView, in direction: Direction) -> Line {
    return Line(startView.frame.centerPoint(in: direction),
                endView.frame.centerPoint(in: direction.opposite))
  }

  private func addLabel(with plan: ArrowDrawingPlan, config: ArrowConfig, startView: UIView) {
    guard let title = plan.arrow.title else { return }
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
}

private extension CGPoint {
  func offset(_ direction: Direction, for offset: CGFloat) -> CGPoint {
    switch direction {
    case .up: return CGPoint(x: x, y: y - offset)
    case .right: return CGPoint(x: x + offset, y: y)
    case .down: return CGPoint(x: x, y: y + offset)
    case .left: return CGPoint(x: x - offset, y: y)
    }
  }
}

private extension CGRect {
  var centerBottom: CGPoint { CGPoint(x: midX, y: maxY) }
  var centerTop: CGPoint { CGPoint(x: midX, y: minY) }
  var centerLeft: CGPoint { CGPoint(x: minX, y: midY) }
  var centerRight: CGPoint { CGPoint(x: maxX, y: midY) }

  func centerPoint(in direction: Direction) -> CGPoint {
    switch direction {
    case .up: return centerTop
    case .left: return centerLeft
    case .down: return centerBottom
    case .right: return centerRight
    }
  }
}
