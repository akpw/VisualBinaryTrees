//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// Builds simple layout for binary trees,
/// without bothering too much about both minimal width and the aesthetics.
/// Runs in O(n) time.
public struct TreeLayoutBuilderKnuth: TreeLayoutBuilder {
    public mutating func buildLayout<Node: BinaryTree>
        (rootNode: Node, gridUnitSize: CGFloat) -> TreeLayout<Node> {
        xCounter = 0
        let treeLayout = TreeLayout<Node>(rootNode: rootNode, gridUnitSize: gridUnitSize)
        buildLayout(treeLayout: treeLayout)
        
        return treeLayout
    }
    
    // MARK: - Private
    private var xCounter = 0
    private mutating func buildLayout<Node: BinaryTree>
        (treeLayout: TreeLayout<Node>, depth: Int = 0) {
        if let leftLayout = treeLayout.left {
            buildLayout(treeLayout: leftLayout, depth: depth + 1)
        }
        treeLayout.logicalX = xCounter
        treeLayout.logicalY = depth
        xCounter += 1
        if let rightLayout = treeLayout.right {
            buildLayout(treeLayout: rightLayout, depth: depth + 1)
        }
    }
}
