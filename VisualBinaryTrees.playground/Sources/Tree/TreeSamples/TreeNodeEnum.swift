//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// A Sample Tree Node implemented as an Enum
public indirect enum TreeNodeEnum<Element: Comparable> {
    case empty
    case node(value: Element, left: TreeNodeEnum, right: TreeNodeEnum)
    public init(_ element: Element,
                  left: TreeNodeEnum = .empty, right: TreeNodeEnum = .empty) {
        self = .node(value: element, left: left, right: right)
    }
}

/// Conformance to BinaryTree Type
extension TreeNodeEnum: QuickLookableBinaryTree {
    public var left: TreeNodeEnum? {
        if case let .node(value: _, left: left, right: _) = self {
            if case .empty = left { return nil }
            return left
        }
        return nil
    }
    public var right: TreeNodeEnum? {
        if case let .node(value: _, left: _, right: right) = self {
            if case .empty = right { return nil }
            return right
        }
        return nil
    }
    public var element: Element {
        if case let .node(value: value, left: _, right: _) = self {
            return value
        }
        fatalError("element can not be empty")
    }
}

extension TreeNodeEnum: BinarySearchTree {
    public func insert(_ element: Element) -> TreeNodeEnum {
        switch self {
        case .empty:
            return TreeNodeEnum(element)
        case let .node(value, left, right):
            if element < value {
                return TreeNodeEnum(value, left: left.insert(element), right: right)
            } else {
                return TreeNodeEnum(value, left: left, right: right.insert(element))
            }
        }
    }
}

extension TreeNodeEnum: ExpressibleByArrayLiteral {
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
        self = minimalHeightSequence.dropFirst().reduce(TreeNodeEnum(first)) { $0.insert($1) }
    }
}




