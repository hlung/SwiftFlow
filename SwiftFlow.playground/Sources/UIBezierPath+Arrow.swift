import UIKit

public class ArrowParameters {
  public let tailWidth: CGFloat
  public let headWidth: CGFloat
  public let headLength: CGFloat

  public init(tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) {
    self.tailWidth = tailWidth
    self.headWidth = headWidth
    self.headLength = headLength
  }
}

public extension UIBezierPath {
  static func arrow(from start: CGPoint, to end: CGPoint, parameters: ArrowParameters) -> UIBezierPath {
    let length = hypot(end.x - start.x, end.y - start.y)
    let tailLength = length - parameters.headLength

    func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
    let points: [CGPoint] = [
      p(0, parameters.tailWidth / 2),
      p(tailLength, parameters.tailWidth / 2),
      p(tailLength, parameters.headWidth / 2),
      p(length, 0),
      p(tailLength, -parameters.headWidth / 2),
      p(tailLength, -parameters.tailWidth / 2),
      p(0, -parameters.tailWidth / 2)
    ]

    let cosine = (end.x - start.x) / length
    let sine = (end.y - start.y) / length
    let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)

    let path = CGMutablePath()
    path.addLines(between: points, transform: transform)
    path.closeSubpath()

    return self.init(cgPath: path)
  }
}
