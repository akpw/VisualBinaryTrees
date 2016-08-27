//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// A Sample Tree implemented as a reference type
public final class TreeNodeRef<Element: Comparable>: QuickLookableBinaryTree,
                                                     TraversableBinaryTree  {
    public var element: Element
    public var left: TreeNodeRef?
    public var right: TreeNodeRef?
    
    // default is in-order traversal
    public var traversalStrategy: TraversalStrategy.Type? = InOrderTraversalStrategy.self
    public init(_ element: Element) { self.element = element }
}
extension TreeNodeRef: BinarySearchTree {
    public func insert(_ element: Element) {
        if element < self.element {
            if let l = left { l.insert(element) }
            else { left = TreeNodeRef(element) }
        } else {
            if let r = right { r.insert(element) }
            else { right = TreeNodeRef(element) }
        }
    }
}

extension TreeNodeRef: ExpressibleByArrayLiteral {
    convenience public init <S: Sequence>(_ elements: S) where S.Iterator.Element == Element {
        self.init(elements: Array(elements))
    }
    
    convenience public init(arrayLiteral elements: Element...) {
        self.init(elements: elements)
    }
    
    convenience public init(elements: [Element]) {
        let minimalHeightSequence = SequenceHelper.minimalHeightBSTSequence(elements: elements)
        guard let first = minimalHeightSequence.first(where: { _ in true })
            else { fatalError("can not init a tree from an empty sequence") }
        self.init(first)
        for value in minimalHeightSequence.dropFirst() {
            insert(value)
        }
    }
}

