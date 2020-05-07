import UIKit

class ArrowDrawingPlan {
  public let startView: SFView
  public let endView: SFView
  public let arrow: ArrowProviding

  public init(startView: SFView, endView: SFView, arrow: ArrowProviding) {
    self.startView = startView
    self.endView = endView
    self.arrow = arrow
  }
}
