import UIKit

// Side center points
public extension CGRect {
  var centerBottom: CGPoint { CGPoint(x: origin.x + (size.width/2), y: origin.y + size.height) }
  var centerTop: CGPoint { CGPoint(x: origin.x + (size.width/2), y: origin.y) }
  var centerLeft: CGPoint { CGPoint(x: origin.x, y: origin.y + (size.height/2)) }
  var centerRight: CGPoint { CGPoint(x: origin.x + size.width, y: origin.y + (size.height/2)) }
}
