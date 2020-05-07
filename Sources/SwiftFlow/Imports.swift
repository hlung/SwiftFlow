#if canImport(UIKit)
import UIKit
typealias SFView = UIView
#else
import AppKit
typealias SFView = NSView
#endif
