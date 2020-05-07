#if canImport(UIKit)
import UIKit
public typealias SFView = UIView
public typealias SFColor = UIColor
public typealias SFBezierPath = UIBezierPath
#else
import AppKit
public typealias SFView = NSView
public typealias SFColor = NSColor
public typealias SFBezierPath = NSBezierPath
#endif
