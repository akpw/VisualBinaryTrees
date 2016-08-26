//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// Base TreeRenderer protocol
public protocol TreeRenderer {
    associatedtype Renderer
    var draw: (Renderer)->() { get set }
}
extension TreeRenderer where Self: UIView {
    public var view: UIView { get { return self } }
}

/// Base class for UIView tree renderers
public class UIViewRenderer: UIView, TreeRenderer {
    public var draw: (Renderer)->() = { _ in () }
}

/// Renders trees using Core Graphics
public class CoreGraphicsTreeRenderer: UIViewRenderer {
    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        self.context = context
        draw(self)
        self.context = nil
        
        context.restoreGState()
    }    
    // private
    fileprivate var idx = 0
    fileprivate var context: CGContext?
    fileprivate var keyRects: [CGRect] = []
    fileprivate lazy var circleLayer: CAShapeLayer = {
        $0.fillColor = #colorLiteral(red: 0.8949507475, green: 0.1438436359, blue: 0.08480125666, alpha: 1).cgColor
        $0.opacity = 0.05
        self.layer.addSublayer($0)
        return $0
    }( CAShapeLayer() )
}

// MARK: - Core Renderer extensions
extension CoreGraphicsTreeRenderer: Renderer {
    /// Overrides the default implementation
    public func renderTraversal(at keyRects: [CGRect]) {
        self.keyRects = keyRects.map {
            let diameter: CGFloat = min($0.size.width, $0.size.height)
            let rect = CGRect(origin: CGPoint(x: $0.origin.x, y: $0.origin.y),
                              size: CGSize(width: diameter, height: diameter))
            return rect
        }
        animateCircleLayer()
    }
    
    // fwd the rest of rendering to the CGContext conformer
    public func renderRect(_ rect: CGRect) {
        guard let context = self.context else { return }
        context.renderRect(rect)
    }
    public func renderLine(from:  CGPoint, to: CGPoint) {
        guard let context = context else { return }
        context.renderLine(from: from, to: to)
    }
    public func strokePath() {
        guard let context = context else { return }
        context.strokePath()
    }
    public func configureLine(color: UIColor, width: CGFloat, dotted: Bool) {
        guard let context = context else { return }
        context.configureLine(color: color, width: width, dotted: dotted)
    }
}

// MARK: - Traversal Animation
extension CoreGraphicsTreeRenderer {
    func animateCircleLayer() {
        if idx >= keyRects.count { idx = 0 }
        let keyRect = keyRects[idx]; idx += 1
        
        let scaleFactor: CGFloat = 0.10
        let fromRect = keyRect.insetBy(dx: -(keyRect.maxX - keyRect.minX) * scaleFactor,
                                       dy: -(keyRect.maxY - keyRect.minY) * scaleFactor)
        let toRect = keyRect.insetBy(dx: (keyRect.maxX - keyRect.minX) * scaleFactor,
                                     dy: (keyRect.maxY - keyRect.minY) * scaleFactor)
        
        let scale = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        scale.fromValue = UIBezierPath(ovalIn: fromRect).cgPath
        scale.toValue = UIBezierPath(ovalIn: toRect).cgPath
        
        let fadeInOut = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
        fadeInOut.keyTimes = [0.0, 0.3, 0.6, 0.8, 1.0]
        fadeInOut.values = [0.05, 0.15, 0.4, 0.15, 0.05]

        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1.0
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.animations = [scale, fadeInOut]
        circleLayer.add(groupAnimation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            self.animateCircleLayer()
        }
    }
}
