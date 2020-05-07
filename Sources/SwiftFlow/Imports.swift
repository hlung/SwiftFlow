#if canImport(UIKit)
import UIKit
public typealias SFView = UIView
public typealias SFColor = UIColor
#else
import AppKit
public typealias SFView = NSView
public typealias SFColor = NSColor
#endif
