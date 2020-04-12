import UIKit

//public extension UIView {
//  func addArrowLayer(with plan: ArrowDrawingPlan) {
//    let parameters = ArrowConfig(tailWidth: 2, headWidth: 7, headLength: 7)
//    let startView: UIView = plan.startView
//    let endView: UIView = plan.endView
//
//    let layer: CAShapeLayer
//    switch plan.arrow.direction {
//    case .up:
//      layer = CAShapeLayer.arrow(from: startView.frame.centerTop,
//                                 to: endView.frame.centerBottom,
//                                 parameters: parameters)
//    case .right:
//      layer = CAShapeLayer.arrow(from: startView.frame.centerRight,
//                                 to: endView.frame.centerLeft,
//                                 parameters: parameters)
//    case .down:
//      layer = CAShapeLayer.arrow(from: startView.frame.centerBottom,
//                                 to: endView.frame.centerTop,
//                                 parameters: parameters)
//    case .left:
//      layer = CAShapeLayer.arrow(from: startView.frame.centerLeft,
//                                 to: endView.frame.centerRight,
//                                 parameters: parameters)
//    }
//    self.layer.addSublayer(layer)
//  }
//}
