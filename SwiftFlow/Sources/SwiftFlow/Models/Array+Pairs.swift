import Foundation

public extension Array {
  // Iterate through all elements in pair tuples
  // e.g. [1, 2, 3, 4].allPairs = [(1, 2), (2, 3), (3, 4)]
  var allPairs: [(Element, Element)] {
    var array: [(Element, Element)] = []
    for i in 0..<self.count - 1 {
      array.append((self[i], self[i+1]))
    }
    return array
  }
}
