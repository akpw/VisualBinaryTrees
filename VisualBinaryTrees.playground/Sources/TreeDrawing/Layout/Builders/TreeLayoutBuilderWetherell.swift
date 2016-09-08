//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// Builds minimal width layout for binary trees,
/// without bothering too much with the aesthetics.
/// Runs in O(n) time.
public struct TreeLayoutBuilderWetherell: TreeLayoutBuilder {
    public mutating func buildLayout<Node: BinaryTree>(rootNode: Node, gridUnitSize: CGFloat) -> TreeLayout<Node> {
        xCounters = Array(repeating: 0, count: rootNode.height + 1)
        let treeLayout = TreeLayout<Node>(rootNode: rootNode, gridUnitSize: gridUnitSize)
        buildLayout(treeLayout: treeLayout)
        return treeLayout
    }
    // MARK: - Private
    private var xCounters = [Int]()
    private mutating func buildLayout<Node: BinaryTree>(treeLayout: TreeLayout<Node>, depth: Int = 0) {
        treeLayout.logicalX = xCounters[depth]
        treeLayout.logicalY = depth
        xCounters[depth] += 1
        if let leftLayout = treeLayout.left {
            buildLayout(treeLayout: leftLayout, depth: depth + 1)
        }
        if let rightLayout = treeLayout.right {
            buildLayout(treeLayout: rightLayout, depth: depth + 1)
        }
    }
}
