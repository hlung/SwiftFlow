import UIKit

/// This is the central piece that holds all information on how to draw the flowchart.
public class Graph {
  public var flows: [[GraphElement]] = []
  public var nodeConfig = NodeConfig()
  public var arrowConfig = ArrowConfig()

  public init(nodeConfig: NodeConfig = NodeConfig(), arrowConfig: ArrowConfig = ArrowConfig(), flows: [[GraphElement]] = []) {
    self.flows = flows
    self.nodeConfig = nodeConfig
    self.arrowConfig = arrowConfig
  }

  public func addFlow(_ elements: [GraphElement]) {
    flows.append(elements)
  }
}
