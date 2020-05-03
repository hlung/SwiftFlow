import UIKit

class ArrowDrawingPlan {
  public let startView: UIView
  public let endView: UIView
  public let arrow: Arrow

  public init(startView: UIView, endView: UIView, arrow: Arrow) {
    self.startView = startView
    self.endView = endView
    self.arrow = arrow
  }
}
