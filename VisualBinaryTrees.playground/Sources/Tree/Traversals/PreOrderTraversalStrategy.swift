//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import Foundation

/// Pre-Order Traversal Strategy
public struct PreOrderTraversalStrategy: TraversalStrategy {
    public static func traversalSequence<Node: BinaryTree>(_ rootNode: Node) -> AnySequence<Node> {
        return AnySequence {  Void -> AnyIterator<Node> in
            var stack = [rootNode]
            return AnyIterator {
                while !stack.isEmpty {
                    let node = stack.removeLast()
                    if let right = node.right { stack.append(right) }
                    if let left = node.left { stack.append(left) }
                    return node
                }
                return nil
            }
        }
    }
}

