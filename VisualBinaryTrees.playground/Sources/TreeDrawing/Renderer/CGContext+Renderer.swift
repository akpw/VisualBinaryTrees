//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit
import CoreGraphics

/// CGContext Renderer
extension CGContext: Renderer {
    public func renderLine(from: CGPoint, to: CGPoint) {
        let fromX = round(from.x + 0.5), fromY = round(from.y + 0.5)
        let toX = round(to.x + 0.5), toY = round(to.y + 0.5)
        self.move(to: CGPoint(x: fromX, y: fromY))
        self.addLine(to: CGPoint(x: toX, y: toY))
    }
    
    public func renderRect(_ rect: CGRect) {
        let rect = CGRect(x: round(rect.origin.x), y: round(rect.origin.y),
                          width: round(rect.size.width), height: round(rect.size.height))
        self.addRect(rect)
    }
    
    public func configureLine(color: UIColor, width: CGFloat,  dotted: Bool = false) {
        self.setStrokeColor(color.cgColor)
        self.setLineWidth(width)
        if dotted {
            let dashes: [CGFloat] = [width * 0, width * 3]
            self.setLineDash(phase: 0, lengths: dashes)
            self.setLineCap(.round)
        }
    }
}


