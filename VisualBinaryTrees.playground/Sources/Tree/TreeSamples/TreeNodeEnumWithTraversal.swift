//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.


/// A Sample Tree Node implemented as an Enum with Pluggable Traversals
public indirect enum TreeNodeEnumTraversal<Element: Comparable> {
    case empty
    case node(value: Element,
              left: TreeNodeEnumTraversal,
              right: TreeNodeEnumTraversal,
              traversal: TraversalStrategy.Type?)
    public init(_ element: Element,
                left: TreeNodeEnumTraversal = .empty,
                right: TreeNodeEnumTraversal = .empty,
                // default is in-order traversal
                traversal: TraversalStrategy.Type? = InOrderTraversalStrategy.self) {
        self = .node(value: element, left: left, right: right, traversal: traversal)
    }
}

/// Conformance to BinaryTree Type 
extension TreeNodeEnumTraversal: QuickLookableBinaryTree {
    public var left: TreeNodeEnumTraversal? {
        if case let .node(value: _, left: left, right: _, traversal: _) = self {
            if case .empty = left { return nil }
            return left
        }
        return nil
    }
    public var right: TreeNodeEnumTraversal? {
        if case let .node(value: _, left: _, right: right, traversal: _) = self {
            if case .empty = right { return nil }
            return right
        }
        return nil
    }
    public var element: Element {
        if case let .node(value: value, left: _, right: _, traversal: _) = self {
            return value
        }
        fatalError("element can not be empty")
    }
}

extension TreeNodeEnumTraversal: TraversableBinaryTree {
    public var traversalStrategy: TraversalStrategy.Type? {
        get {
            if case let .node(value: _, left: _, right: _, traversal: traversal) = self {
                return traversal.self
            }
            return nil
        }
        set(newValue) {
            if case let .node(value, left, right, _) = self {
                self = TreeNodeEnumTraversal(value, left: left, right: right, traversal: newValue)
            }
        }
    }
}

extension TreeNodeEnumTraversal: BinarySearchTree {
    public func insert(_ element: Element, traversalStrategy: TraversalStrategy.Type? = nil) -> TreeNodeEnumTraversal {
        switch self {
        case .empty:
            return TreeNodeEnumTraversal(element, left: .empty, right: .empty, traversal: traversalStrategy)
        case let .node(value, left, right, traversal):
            if element < value {
                return TreeNodeEnumTraversal(value, left: left.insert(element), right: right, traversal: traversal)
            } else {
                return TreeNodeEnumTraversal(value, left: left, right: right.insert(element), traversal: traversal)
            }
        }
    }
}

extension TreeNodeEnumTraversal: ExpressibleByArrayLiteral {
    public init <S: Sequence>(_ elements: S) where S.Iterator.Element == Element {
        self.init(elements: Array(elements))
    }
    
    public init(arrayLiteral elements: Element...) {
        self.init(elements: elements)
    }
    
    public init(elements: [Element]) {
        let minimalHeightSequence = SequenceHelper.minimalHeightBSTSequence(elements: elements)
        guard let first = minimalHeightSequence.first(where: { _ in true })
            else { fatalError("can not init a tree from an empty sequence") }
        self = minimalHeightSequence.dropFirst().reduce(TreeNodeEnumTraversal(first)) { $0.insert($1) }
    }
}

