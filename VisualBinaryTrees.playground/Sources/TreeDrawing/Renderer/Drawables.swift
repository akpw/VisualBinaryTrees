//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// Base Drawable protocol
public protocol Drawable {
    mutating func draw(_ renderer: Renderer)
}

/// Drawable Rectangle
public struct Rectangle: Drawable {
    var bounds: CGRect
    public func draw(_ rect: Renderer) {
        rect.renderRect(bounds)
    }
}

/// Drawable Grid
public struct Grid: Drawable {
    var bounds: CGRect
    var gridUnitSize: CGFloat
    var lineWidth: CGFloat
    
    public func draw(_ r: Renderer) {
        let insetRect = CGRect(x: round(bounds.origin.x + 0.5), y: (bounds.origin.y + 0.5),
                               width: round(bounds.size.width - 1.0),
                               height: round(bounds.size.height - 1.0)).insetBy(dx: lineWidth / 2,
                                                                                dy: lineWidth / 2)
        r.renderRect(insetRect)
        r.strokePath()
        let numLines = Int(insetRect.size.height / gridUnitSize)
        let rectsInLine = Int(insetRect.size.width / gridUnitSize) + 1
        for y in 0...numLines {
            let yCoordinate = CGFloat(y) * gridUnitSize
            let start = (y % 2 == 0) ? 0 : 0 //1
            for x in stride(from: start, to: rectsInLine, by: 1/*2*/) {
                let rect = CGRect(x: CGFloat(x) * gridUnitSize, y: yCoordinate,
                                  width: gridUnitSize, height: gridUnitSize)
                r.renderRect(rect)
            }
        }
    }
}
