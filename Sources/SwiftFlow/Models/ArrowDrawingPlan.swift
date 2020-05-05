import UIKit

class ArrowDrawingPlan {
  public let startView: UIView
  public let endView: UIView
  public let arrow: ArrowProviding

  public init(startView: UIView, endView: UIView, arrow: ArrowProviding) {
    self.startView = startView
    self.endView = endView
    self.arrow = arrow
  }
}
