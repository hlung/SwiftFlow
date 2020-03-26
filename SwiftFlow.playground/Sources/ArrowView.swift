import UIKit

public class ArrowView: UIView {
  let parameters: ArrowParameters = ArrowParameters(tailWidth: 2, headWidth: 10, headLength: 10)

  public init() {
    super.init(frame: .zero)
    self.backgroundColor = .red
    self.clipsToBounds = false
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func draw(_ rect: CGRect) {
    let offset = parameters.headWidth / 2
    let arrow = UIBezierPath.arrow(from: CGPoint(x: offset, y: offset),
                                   to: CGPoint(x: rect.width - offset, y: rect.height - offset),
                                   parameters: parameters)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = arrow.cgPath
    self.layer.addSublayer(shapeLayer)
  }
}

    /*
    // Experiment: draw arrow vertically
    let arrowView = ArrowView()
    graphView.addSubview(arrowView)
    graphView.sendSubviewToBack(arrowView)

    let aWidth = arrowView.parameters.headWidth
    let aOffset = arrowView.parameters.headWidth / 2
    constraints += [
      arrowView.widthAnchor.constraint(greaterThanOrEqualToConstant: aWidth),
      arrowView.heightAnchor.constraint(greaterThanOrEqualToConstant: aWidth),
//      arrowView.topAnchor.constraint(equalTo: firstBox.bottomAnchor, constant: -aOffset),
//      arrowView.bottomAnchor.constraint(equalTo: secondBox.topAnchor, constant: aOffset),
    ]

    if firstBox.center.x < secondBox.center.x {
      constraints += [
        arrowView.leadingAnchor.constraint(equalTo: firstBox.centerXAnchor, constant: -aOffset),
        arrowView.trailingAnchor.constraint(equalTo: secondBox.centerXAnchor, constant: aOffset),
      ]
    }
    else {
      constraints += [
        arrowView.leadingAnchor.constraint(equalTo: secondBox.centerXAnchor, constant: -aOffset),
        arrowView.trailingAnchor.constraint(equalTo: firstBox.centerXAnchor, constant: aOffset),
      ]
    }
    */

//extension Array where Element == UIView {
//  func drawArrowTopToBottom() {
//    for i in 0..<self.count - 1 {
//      let firstView = self[i]
//      let secondView = self[i+1]
//
//    }
//  }
//}
