import Foundation
import SwiftUI

struct GraphViewWrapper: NSViewRepresentable {
//  @Binding var text: String

  func makeNSView(context: Context) -> NSView {
    let view = NSView()
    view.layer?.backgroundColor = .white
    return view
  }

  func updateNSView(_ nsView: NSView, context: Context) {
  }
}
