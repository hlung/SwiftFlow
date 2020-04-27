//
//extension StringProtocol {
//  func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
//    range(of: string, options: options)?.lowerBound
//  }
//}
//
//extension String {
//  // Example:
//  // var s = "Start"
//  // s.pull(2) // St
//  // s // art
//  mutating func pull(_ n: Int) -> String? {
//    let string = self.prefix(n)
//    guard string.count == n else { return nil }
//    self = String(self.dropFirst(n))
//    return String(string)
//  }
//
//  mutating func pullUntil(_ ending: String) -> String? {
//    guard let endingIndex = self.index(of: ending) else { return nil }
//    let string = self.prefix(upTo: endingIndex)
//    self = String(self.dropFirst(distance(from: self.startIndex, to: endingIndex)))
//    return String(string)
//  }
//}

//let string = """
//() Start
//v
//[] API Client receives responses
//v
//<> Success?
//-YES-> Handle success :: result_yes, Direction.right
//-NO-> Handle failure :: result_no
//
//result_yes
//v
//[] Print Yay
//
//result_no
//v
//[] Print Cry
//
//vv
//() End
//"""

//public struct Node: CustomStringConvertible {
//  // NodeShape (first two characters)
//  // |  Title (all strings until end of line or :: )
//  // |  |        ID (optional, all strings until end)
//  // |  |        |
//  // v  v        v
//  // () Title :: id
//
//  public enum NodeShape {
//    case rect
//    case diamond
//
//    init?(rawType: String) {
//      switch rawType {
//      case "[]": self = .rect
//      case "()": self = .rect
//      case "<>": self = .diamond
//      default: return nil
//      }
//    }
//  }
//
//  public enum InitError: Error {
//    case invalidType
//  }
//
//  let type: NodeShape
//  let title: String
//  let id: String?
//
//  init(string: String) throws {
//    var s = string
//    guard let rawType = s.pull(2), let type = NodeShape(rawType: rawType) else { throw InitError.invalidType }
//    self.type = type
//
//    self.title = "Hello"
//    self.id = nil
//  }
//
//  public var description: String {
//    return "[Node \(type) title: \(title) id: \(id ?? "-")]"
//  }
//}
//
//let b = try Node(string: "() Start")
