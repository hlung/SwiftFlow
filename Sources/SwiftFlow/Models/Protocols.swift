import Foundation

public protocol GraphElement {}

public protocol ArrowProviding {
  var direction: Direction { get }
  var title: String? { get }
  var config: ArrowConfig? { get }
}
