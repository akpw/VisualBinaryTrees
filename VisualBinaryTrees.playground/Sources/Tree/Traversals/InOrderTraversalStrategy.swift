//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import Foundation

/// In-Order Traversal Strategy
public struct InOrderTraversalStrategy: TraversalStrategy {
    public static func traversalSequence<Node: BinaryTree>(_ rootNode: Node) -> AnySequence<Node> {
        return AnySequence {  Void -> AnyIterator<Node> in
            var currentNode: Node? = rootNode
            var stack = [Node]()
            return AnyIterator {
                while !(currentNode == nil && stack.isEmpty) {
                    if let node = currentNode {
                        stack.append(node)
                        currentNode = node.left
                    } else {
                        let node = stack.removeLast()
                        currentNode = node.right
                        return node
                    }
                }
                return nil
            }
        }
    }
}

