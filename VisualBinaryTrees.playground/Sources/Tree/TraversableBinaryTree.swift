//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import Foundation

/// Binary Tree with Pluggable Traversals
public protocol TraversableBinaryTree: BinaryTree, Sequence,
                                                   CustomStringConvertible,
                                                   CustomDebugStringConvertible {
    var traversalStrategy: TraversalStrategy.Type?  { get }
}

// MARK: - Sequence conformance
extension TraversableBinaryTree {
    public func makeIterator() -> AnyIterator<Self> {
        guard let traversalStrategy = traversalStrategy else { return AnyIterator { nil } }
        return traversalStrategy.traversalSequence(self).makeIterator()
    }
}

// MARK: - Conformance to CustomStringConvertible and CustomDebugStringConvertible
extension TraversableBinaryTree {
    public var description: String {
        let currentTraversal = self.traversalStrategy == nil ? "" : "\(self.traversalStrategy!): "
        var values = [String]()
        for case let node as Self in self {
            values.append(String(describing: node.element))
        }
        return currentTraversal + values.joined(separator: ", ")
    }
    public var debugDescription: String { return description }
}


