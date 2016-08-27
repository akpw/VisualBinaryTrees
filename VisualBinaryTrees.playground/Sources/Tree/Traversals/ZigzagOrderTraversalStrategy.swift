//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import Foundation

/// Zigzag-Order Traversal Strategy
public struct ZigzagOrderTraversalStrategy: TraversalStrategy {
    public static func traversalSequence<Node: BinaryTree>(_ rootNode: Node) -> AnySequence<Node> {
        return AnySequence {  Void -> AnyIterator<Node> in
            var leftToRightStack: [Node] = [rootNode], rightToLeftStack: [Node] = []
            var leftToRight = true
            return AnyIterator {
                while !(leftToRightStack.isEmpty && rightToLeftStack.isEmpty) {
                    while !leftToRightStack.isEmpty && leftToRight {
                        let node = leftToRightStack.removeLast()
                        if let left = node.left { rightToLeftStack.append(left) }
                        if let right = node.right { rightToLeftStack.append(right) }
                        return node
                    }
                    while !rightToLeftStack.isEmpty {
                        leftToRight = false
                        let node = rightToLeftStack.removeLast()
                        if let right = node.right { leftToRightStack.append(right) }
                        if let left = node.left { leftToRightStack.append(left)  }
                        return node
                    }
                    leftToRight = true
                }
                return nil
            }
        }
    }
}
