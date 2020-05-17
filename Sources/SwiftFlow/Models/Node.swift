import Foundation

/// Each rectangle / other shapes boxes you see are backed by this type.
public struct Node: GraphElement, CustomStringConvertible {
  public let title: String
  public let shape: NodeShape
  public let id: String
  public let config: NodeConfig?

  public var description: String {
    return "[Node \"\(title)\" shape: \(shape) id: \(id)]"
  }

  public init(_ title: String,
              shape: NodeShape = .rect,
              id: String = UUID().uuidString,
              config: NodeConfig? = nil) {
    self.title = title
    self.shape = shape
    self.id = id
    self.config = config
  }
}

struct DummyNode: GraphElement {}

///  A way to refer to an *existing* Node by `id`.
public struct NodeShortcut: GraphElement, CustomStringConvertible {
  public let id: String

  public var description: String {
    return "[NodeShortcut id: \(id)]"
  }

  public init(id: String) {
    self.id = id
  }
}
