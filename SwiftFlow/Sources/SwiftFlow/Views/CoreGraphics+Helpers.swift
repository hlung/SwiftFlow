import UIKit

// Side center points
public extension CGRect {
  var centerBottom: CGPoint { CGPoint(x: midX, y: maxY) }
  var centerTop: CGPoint { CGPoint(x: midX, y: minY) }
  var centerLeft: CGPoint { CGPoint(x: minX, y: midY) }
  var centerRight: CGPoint { CGPoint(x: maxX, y: midY) }
}

func midPoint(_ pointA: CGPoint, _ pointB: CGPoint) -> CGPoint {
  return CGPoint(x: (pointA.x + pointB.x) / 2,
                 y: (pointA.y + pointB.y) / 2)
}
