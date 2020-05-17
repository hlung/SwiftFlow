import CoreGraphics

#if canImport(AppKit)

import AppKit
public typealias UIView = NSView
public typealias UILabel = NSTextField
public typealias UIColor = NSColor
public typealias UIBezierPath = NSBezierPath
public typealias UIEdgeInsets = NSEdgeInsets
public typealias UILayoutGuide = NSLayoutGuide

extension UIView {
  @objc func layoutSubviews() {
    layout()
  }

  func layoutIfNeeded() {
    layoutSubtreeIfNeeded()
  }

  func addSublayer(_ l: CALayer) {
    #if canImport(UIKit)
    self.layer.addSublayer(l)
    #else
    self.layer?.addSublayer(l)
    #endif
  }

  var backgroundColor: UIColor {
    get { UIColor(cgColor: layer?.backgroundColor ?? CGColor.white)! }
    set { layer?.backgroundColor = newValue.cgColor }
  }
}

extension UILabel {
  var text: String? {
    get { stringValue }
    set { stringValue = newValue ?? "" }
  }

  var textAlignment: NSTextAlignment {
    get { alignment }
    set { alignment = newValue }
  }

  var numberOfLines: Int {
    get { usesSingleLineMode ? 1 : 0 }
    set { usesSingleLineMode = newValue == 1 }
  }
}

extension UIBezierPath {
  var cgPath: CGPath {
    get {
      let path = CGMutablePath()
      var points = [CGPoint](repeating: .zero, count: 3)

      for i in 0 ..< self.elementCount {
        let type = self.element(at: i, associatedPoints: &points)
        switch type {
        case .moveTo:
          path.move(to: points[0])
        case .lineTo:
          path.addLine(to: points[0])
        case .curveTo:
          path.addCurve(to: points[2], control1: points[0], control2: points[1])
        case .closePath:
          path.closeSubpath()
        @unknown default:
          break
        }
      }
      return path
    }
    set {
      let path = newValue

      // From: https://gist.github.com/lukaskubanek/1f3585314903dfc66fc7

      let pathPtr = UnsafeMutablePointer<NSBezierPath>.allocate(capacity: 1)
      pathPtr.initialize(to: self)

      let infoPtr = UnsafeMutableRawPointer(pathPtr)

      // I hope the CGPathApply call manages the deallocation of the pointers passed to the applier
      // function, but I'm not sure.
      path.apply(info: infoPtr) { (infoPtr, elementPtr) -> Void in
        let path = infoPtr!.load(as: NSBezierPath.self)
        let element = UnsafeMutableRawPointer(mutating: elementPtr).load(as: CGPathElement.self)

        let pointsPtr = UnsafeMutableRawPointer(mutating: element.points)
        let point = pointsPtr.load(as: CGPoint.self)

        switch element.type {
        case .moveToPoint:
          path.move(to: point)

        case .addLineToPoint:
          path.line(to: point)

        case .addQuadCurveToPoint:
          let firstPoint = point
          let secondPoint = pointsPtr.successor().load(as: CGPoint.self)

          let currentPoint = path.currentPoint
          let x = (currentPoint.x + 2 * firstPoint.x) / 3
          let y = (currentPoint.y + 2 * firstPoint.y) / 3
          let interpolatedPoint = CGPoint(x: x, y: y)

          let endPoint = secondPoint

          path.curve(to: endPoint, controlPoint1: interpolatedPoint, controlPoint2: interpolatedPoint)

        case .addCurveToPoint:
          let firstPoint = point
          let secondPoint = pointsPtr.successor().load(as: CGPoint.self)
          let thirdPoint = pointsPtr.successor().successor().load(as: CGPoint.self)

          path.curve(to: thirdPoint, controlPoint1: firstPoint, controlPoint2: secondPoint)

        case .closeSubpath:
          path.close()

        @unknown default:
          break
        }

//        pointsPtr.deallocate()
      }

    }
  }

  func addLine(to point: NSPoint) {
    line(to: point)
  }

//  convenience init(cgPath: CGPath) {
//    self.init()
//    self.cgPath = cgPath
//  }

}

#endif
