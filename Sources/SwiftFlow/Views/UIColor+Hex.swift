import UIKit

public extension UIColor {
  convenience init(hex: String) {
    let r, g, b, a: CGFloat

    var hex = hex
    if hex.hasPrefix("#") { hex = String(hex.dropFirst()) }

    if hex.count == 6 {
      let scanner = Scanner(string: hex)
      var hexNumber: UInt64 = 0
      if scanner.scanHexInt64(&hexNumber) {
        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        b = CGFloat((hexNumber & 0x0000ff)) / 255
        a = 1.0
        self.init(red: r, green: g, blue: b, alpha: a)
        return
      }
    }
    assertionFailure("Failed to parse color from string: \(hex)")
    self.init(red: 0, green: 0, blue: 0, alpha: 0)
  }
}
