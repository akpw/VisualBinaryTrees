//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit
import CoreGraphics

/// Base Renderer protocol
public protocol Renderer {
    func renderRect(_ rect: CGRect)
    func renderLine(from:  CGPoint, to: CGPoint)
    func renderText(_ text: String, fontSize: CGFloat, fontColor: UIColor, inBoundingRect rect: CGRect)
    func renderTraversal(at keyRects: [CGRect])
    func strokePath()
    func configureLine(color: UIColor, width: CGFloat, dotted: Bool)
}
extension Renderer {
    public func renderText(_ text: String, fontSize: CGFloat, fontColor: UIColor, inBoundingRect rect: CGRect) {
        let (fontThatFits, fontSize) = text.systemFontFittingRect(rect, preferredFontSize: fontSize)
        let deltaX = (rect.size.width - fontSize.width) / 2
        let deltaY = (rect.size.height - fontSize.height) / 2
        text.draw(at: CGPoint(x: round(rect.origin.x + deltaX + 0.5), y: round(rect.origin.y + deltaY + 0.5)),
                  withAttributes: [NSForegroundColorAttributeName: fontColor, NSFontAttributeName: fontThatFits])
    }
    public func renderTraversal(at keyRects: [CGRect]) {
        print("rendering  traversal at key points: \(keyRects)")
    }
}

// MARK: - Local String Extensions
fileprivate extension String {
    /// Calculates UIFont and its size fitting a given rectangle
    func systemFontFittingRect(_ rect: CGRect,
                               preferredFontSize: CGFloat = UIFont.systemFontSize) -> (UIFont, CGSize) {
        var fontThatFits: UIFont, textSize: CGSize
        var ratio: CGFloat, target_size = preferredFontSize, paddingsFactor: CGFloat = 0.88
        
        let nsRepr = self as NSString
        repeat {
            fontThatFits = UIFont.systemFont(ofSize: target_size)
            textSize = nsRepr.size(attributes: [NSFontAttributeName: fontThatFits])
            ratio = min(rect.size.width / textSize.width, rect.size.height / textSize.height)
            target_size *= ratio * paddingsFactor
        } while ratio < 1.0
        return (fontThatFits, textSize)
    }
}



