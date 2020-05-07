import CoreGraphics

extension SFBezierPath {
  static func diamond(_ bounds: CGRect, inset: CGFloat) -> SFBezierPath {
    let path = SFBezierPath()
    path.move(to: CGPoint(x: bounds.midX, y: bounds.minY + inset))
    path.addLine(to: CGPoint(x: bounds.maxX - inset, y: bounds.midY))
    path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY - inset))
    path.addLine(to: CGPoint(x: bounds.minX + inset, y: bounds.midY))
    path.close()
    return path
  }
}
