import CoreGraphics

#if canImport(UIKit)
//import UIKit
#else
import AppKit
public typealias UIView = NSView
public typealias UILabel = NSTextField
public typealias UIColor = NSColor
public typealias UIBezierPath = NSBezierPath
public typealias UIEdgeInsets = NSEdgeInsets
public typealias UILayoutGuide = NSLayoutGuide

//public class UIView: NSView {
//  private var _nsuikit_layoutMargins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//  var layoutMargins: UIEdgeInsets {
//    get { _nsuikit_layoutMargins }
//    set { _nsuikit_layoutMargins = newValue }
//  }
//
//  public override var alignmentRectInsets: NSEdgeInsets {
//    _nsuikit_layoutMargins
//  }
//}

extension UIView {
//  var layoutMarginsGuide: NSLayoutGuide {
//    layoutGuides.first ?? NSLayoutGuide()
////    get { layoutGuides.first ?? NSLayoutGuide() }
////    set { addLayoutGuide(newValue) }
//  }

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

  // TODO: fix
  var numberOfLines: Int {
    get { 0 }
    set {  }
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
      // TODO: https://gist.github.com/lukaskubanek/1f3585314903dfc66fc7
//      let path = newValue
//      let pathPtr = UnsafeMutablePointer<NSBezierPath>.allocate(capacity: 1)
//      pathPtr.initialize(to: self)
//
//      let infoPtr = UnsafeMutableRawPointer(pathPtr)
//
//      // I hope the CGPathApply call manages the deallocation of the pointers passed to the applier
//      // function, but I'm not sure.
//      path.apply(info: infoPtr) { (infoPtr, elementPtr) -> Void in
//        let path = UnsafeMutableRawPointer(infoPtr)?.bindMemory(to: <#T##T.Type#>, capacity: <#T##Int#>)
//        let element = elementPtr.memory
//
//        let pointsPtr = element.points
//
//        switch element.type {
//        case .MoveToPoint:
//          path.moveToPoint(pointsPtr.memory)
//
//        case .AddLineToPoint:
//          path.lineToPoint(pointsPtr.memory)
//
//        case .AddQuadCurveToPoint:
//          let firstPoint = pointsPtr.memory
//          let secondPoint = pointsPtr.successor().memory
//
//          let currentPoint = path.currentPoint
//          let x = (currentPoint.x + 2 * firstPoint.x) / 3
//          let y = (currentPoint.y + 2 * firstPoint.y) / 3
//          let interpolatedPoint = CGPoint(x: x, y: y)
//
//          let endPoint = secondPoint
//
//          path.curveToPoint(endPoint, controlPoint1: interpolatedPoint, controlPoint2: interpolatedPoint)
//
//        case .AddCurveToPoint:
//          let firstPoint = pointsPtr.memory
//          let secondPoint = pointsPtr.successor().memory
//          let thirdPoint = pointsPtr.successor().successor().memory
//
//          path.curveToPoint(thirdPoint, controlPoint1: firstPoint, controlPoint2: secondPoint)
//
//        case .CloseSubpath:
//          path.closePath()
//        }
//
//        pointsPtr.destroy()
//      }
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
