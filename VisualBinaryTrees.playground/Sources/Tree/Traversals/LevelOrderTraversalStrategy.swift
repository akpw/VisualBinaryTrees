//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import Foundation

/// Level-Order Traversal Strategy
public struct LevelOrderTraversalStrategy: TraversalStrategy {
    public static func traversalSequence<Node: BinaryTree>(_ rootNode: Node) -> AnySequence<Node> {
        return AnySequence {  Void -> AnyIterator<Node> in
            var queue = [rootNode]
            return AnyIterator {
                while !queue.isEmpty {
                    let node = queue.removeFirst()
                    if let left = node.left { queue.append(left) }
                    if let right = node.right { queue.append(right) }
                    return node
                }
                return nil
            }
        }
    }
}

