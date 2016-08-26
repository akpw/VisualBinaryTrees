//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import Foundation

/// Post-Order Traversal Strategy
public struct PostOrderTraversalStrategy: TraversalStrategy {
    public static func traversalSequence<Node: BinaryTree>(_ rootNode: Node) -> AnySequence<Node> {
        return AnySequence {  Void -> AnyIterator<Node> in
            var currentNode: Node? = rootNode
            var lastVisited: Node?
            var stack = [Node]()
            return AnyIterator {
                while !(currentNode == nil && stack.isEmpty) {
                    if let node = currentNode {
                        stack.append(node)
                        currentNode = node.left
                    } else {
                        guard let node = stack.last else { return nil }
                        if let right = node.right, lastVisited != right {
                            currentNode = right
                        } else {
                            lastVisited = stack.removeLast()
                            return node
                        }
                    }
                }
                lastVisited = nil
                return nil
            }
        }
    }
}

