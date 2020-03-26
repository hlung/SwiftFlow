import UIKit

// Side center points
public extension CGRect {
  var bottom: CGPoint { CGPoint(x: origin.x + (size.width/2), y: origin.y + size.height) }
  var top: CGPoint { CGPoint(x: origin.x + (size.width/2), y: origin.y) }
  var left: CGPoint { CGPoint(x: origin.x, y: origin.y + (size.height/2)) }
  var right: CGPoint { CGPoint(x: origin.x + size.width, y: origin.y + (size.height/2)) }
}
