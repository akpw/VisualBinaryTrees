//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit
import CoreGraphics

/// Drawable Tree Layout Model
public final class TreeLayout<Node: BinaryTree>: TreeLayoutTopology {
    private(set) public var element: Node.Element
    private(set) public var left: TreeLayout?
    private(set) public var right: TreeLayout?
    private(set) public var height: Int    
    public var traversalStrategy: TraversalStrategy.Type?
    
    private(set) public var gridUnitSize: CGFloat
    
    public var logicalX = -1
    public var logicalY = -1
    
    convenience public init(rootNode: Node, gridUnitSize: CGFloat) {
        let rootHeight = rootNode.height
        self.init(rootNode: rootNode, gridUnitSize: gridUnitSize, nodeHeight: rootHeight)
    }
    
    public init(rootNode: Node, gridUnitSize: CGFloat, nodeHeight: Int) {
        height = nodeHeight
        self.element = rootNode.element
        self.gridUnitSize = gridUnitSize
        
        switch rootNode {
        case let traversableNode as TraversableBinaryTree:
            self.traversalStrategy = traversableNode.traversalStrategy
        default:
            break
        }

        if let left = rootNode.left {
            self.left = TreeLayout(rootNode: left,
                                         gridUnitSize: gridUnitSize,
                                         nodeHeight: nodeHeight - 1)
        }
        if let right = rootNode.right {
            self.right = TreeLayout(rootNode: right,
                                          gridUnitSize: gridUnitSize,
                                          nodeHeight: nodeHeight - 1)
        }
    }
    // internal storage for var used by builders
    internal var extras: Dictionary<String, Any> = [:]
}

/// Tree Layout Topology protocol
protocol TreeLayoutTopology: TraversableBinaryTree {
    var gridUnitSize: CGFloat { get }
    var logicalX: Int { get set }
    var logicalY: Int { get set }
}

/// Tree Layout Topology, some useful extensions
extension TreeLayoutTopology {
    public var maxLogicalX: Int {
        return Swift.max(left?.maxLogicalX ?? 0, logicalX, right?.maxLogicalX ?? 0)
    }
    
    public var layoutWidth: CGFloat { return (CGFloat(maxLogicalX) + 2) * gridUnitSize }
    public var layoutHeight: CGFloat { return (CGFloat(height) + 2) * gridUnitSize }
    
    public var origin: CGPoint {
        return CGPoint(x: (CGFloat(logicalX) + 1) * gridUnitSize,
                       y: (CGFloat(logicalY) + 1) * gridUnitSize)
    }
    public var boundingRect: CGRect {
        let offsetOrigin = CGPoint(x: origin.x - gridUnitSize / 2, y: origin.y - gridUnitSize / 2)
        return CGRect(origin: offsetOrigin, size: CGSize(width: gridUnitSize,  height: gridUnitSize))
    }
    public var childLineAnchor: CGPoint {
        return CGPoint(x: boundingRect.minX + gridUnitSize / 2, y: boundingRect.maxY - gridUnitSize / 5)
    }
    public var parentLineAnchor: CGPoint {
        return CGPoint(x: boundingRect.minX + gridUnitSize / 2, y: boundingRect.minY + gridUnitSize / 5)
    }
}
