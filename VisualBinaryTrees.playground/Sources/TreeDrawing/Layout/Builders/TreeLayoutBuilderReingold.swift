//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// Builds aesthetic-looking binary tree layout with minimal width.
/// Runs in O(n) time
public struct TreeLayoutBuilderReingold: TreeLayoutBuilder {
    public mutating func buildLayout<Node: BinaryTree>(rootNode: Node, gridUnitSize: CGFloat) -> TreeLayout<Node> {
        let treeLayout = TreeLayout<Node>(rootNode: rootNode, gridUnitSize: gridUnitSize)
        
        buildLayout(treeLayout: treeLayout)
        xModify(treeLayout: treeLayout)
        
        return treeLayout
    }
    
    // MARK: - Private
    private mutating func buildLayout<Node: BinaryTree>(treeLayout: TreeLayout<Node>, depth: Int = 0) {
        // build children layout
        for child in treeLayout.children {
            buildLayout(treeLayout: child, depth: depth + 1)
        }
        
        // figure out the coordinates
        treeLayout.logicalY = depth
        switch treeLayout.children.count {
        case 0:
            treeLayout.logicalX = 0
        case 1:
            treeLayout.logicalX = treeLayout.children[0].logicalX
        case 2:
            treeLayout.logicalX = shiftSubtrees(left: treeLayout.children[0], right: treeLayout.children[1])
        default:
            break
        }
    }
    
    // Applies the x-coordinate modifiers
    private func xModify<Node: BinaryTree>(treeLayout: TreeLayout<Node>, xMod: Int = 0) {
        treeLayout.logicalX += xMod
        if let leftLayout = treeLayout.left {
            xModify(treeLayout: leftLayout, xMod: xMod + treeLayout.xMod)
        }
        if let rightLayout = treeLayout.right {
            xModify(treeLayout: rightLayout, xMod: xMod + treeLayout.xMod)
        }
    }
    
    // Optimally shifts subtrees, so the parents are centered over their children
    private func shiftSubtrees<Node: BinaryTree>(left: TreeLayout<Node>, right: TreeLayout<Node>) -> Int {
        var (li, ri, maxOffset, leftOffset, rightOffset, leftOuter, rightOuter) = contour(left: left, right: right)
        
        maxOffset += 1
        // since logicalX is Int, make sure there is no  precision loss
        maxOffset += (right.logicalX + maxOffset + left.logicalX) % 2
        
        right.xMod = maxOffset
        right.logicalX += maxOffset
        
        if right.left != nil || right.right != nil { rightOffset += maxOffset }
        
        if ri  != nil && li == nil {
            // right is deeper than left
            leftOuter?.contourThread = ri
            leftOuter?.xMod = rightOffset - leftOffset
        } else if ri  == nil && li != nil {
            // left is deeper than right
            rightOuter?.contourThread = li
            rightOuter?.xMod = leftOffset - rightOffset
        }
        return (left.logicalX + right.logicalX) / 2
    }
    
    // figures out the contours
    private func contour<Node: BinaryTree>(
                    left: TreeLayout<Node>, right: TreeLayout<Node>,
                    maxOffset: Int = 0, leftOffset: Int = 0, rightOffset: Int = 0,
                    leftOuter: TreeLayout<Node>? = nil, rightOuter: TreeLayout<Node>? = nil) ->
                                                                        (TreeLayout<Node>?, TreeLayout<Node>?,
                                                                        Int, Int, Int,
                                                                        TreeLayout<Node>?, TreeLayout<Node>?) {
            var maxOffset = maxOffset, leftOuter = leftOuter, rightOuter = rightOuter
            var leftOffset = leftOffset, rightOffset = rightOffset
            
            let delta = left.logicalX + leftOffset - (right.logicalX + rightOffset)
            switch maxOffset {
            case let maxOffset where delta > maxOffset:
                fallthrough
            case 0:
                maxOffset = delta
            default:
                break
            }
            if leftOuter  == nil { leftOuter = left }
            if rightOuter == nil { rightOuter = right }
            
            let lo = nextLeft(treeLayout: leftOuter)
            let li = nextRight(treeLayout: left)
            let ri = nextLeft(treeLayout: right)
            let ro = nextRight(treeLayout: rightOuter)
            
            if let li = li, let ri = ri {
                leftOffset += left.xMod
                rightOffset += right.xMod
                return contour(left: li, right: ri, maxOffset:
                               maxOffset, leftOffset: leftOffset, rightOffset: rightOffset,
                               leftOuter: lo, rightOuter: ro)
            }
            return (li, ri, maxOffset, leftOffset, rightOffset, leftOuter, rightOuter)
    }
    
    /// next-right contour node
    private func nextRight<Node: BinaryTree>(treeLayout: TreeLayout<Node>?) -> TreeLayout<Node>? {
        guard let treeLayout = treeLayout else { return nil }
        
        if let thread = treeLayout.contourThread { return thread }
        if let right = treeLayout.right { return right }
        if let left = treeLayout.left { return left }
        return nil
    }
    
    /// next-left contour node
    private func nextLeft<Node: BinaryTree>(treeLayout: TreeLayout<Node>?) -> TreeLayout<Node>? {
        guard let treeLayout = treeLayout else { return nil }
        
        if let thread = treeLayout.contourThread { return thread }
        if let left = treeLayout.left { return left }
        if let right = treeLayout.right { return right }
        return nil
    }
}


/// Additional TreeLayout attributes used for internal purposes
fileprivate struct TreeLayoutExtrasKey {
    static let xMod = "xMod"
    static let contourThread = "contourThread"
}
fileprivate extension TreeLayout {
    /// Mods (modiﬁers) allows linear time when moving subtrees
    var xMod: Int {
        get {
            return extras[TreeLayoutExtrasKey.xMod] as? Int ?? 0
        }
        set(newValue) {
            extras[TreeLayoutExtrasKey.xMod] = newValue
        }
    }
    /// Threads help avoid traversing (lots of) the contour nodes that are not in direct parent/child relationship,
    /// via creating links between these nodes
    var contourThread: TreeLayout? {
        get {
            return extras[TreeLayoutExtrasKey.contourThread] as? TreeLayout
        }
        set(newValue) {
            extras[TreeLayoutExtrasKey.contourThread] = newValue
        }
    }
    var children: [TreeLayout] {
        var children: [TreeLayout] = []
        if let left = left { children.append(left) }
        if let right = right { children.append(right) }
        return children
    }
}
