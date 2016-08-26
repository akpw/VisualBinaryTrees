//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

// Binary Tree Base Type
public protocol BinaryTree: Equatable {
    associatedtype Element: Comparable
    var element: Element { get }
    var left: Self?  { get }
    var right: Self? { get }
}

// Common BinaryTree properties
extension BinaryTree {
    public static func ==(lhs: Self, rhs: Self) -> Bool { return lhs.element == rhs.element }
    
    public var count: Int { return (left?.count ?? 0) + 1 + (right?.count ?? 0) }
    
    public var height: Int {
        var (leftHeight, rightHeight) = (0, 0)
        if let left = left { leftHeight = left.height + 1 }
        if let right = right { rightHeight = right.height + 1 }
        let height = Swift.max(leftHeight, rightHeight)
        return height
    }
    
    public var isBalanced: Bool {
        guard checkBalancedHeight() != -1 else { return false }
        return true
    }
    
    // MARK: - Private
    private func checkBalancedHeight() -> Int {
        // bottom-up, O(n) time + O(tree height) space
        var (leftBalancedHeight, rightBalancedHeight) = (0, 0)
        if let left = left {
            leftBalancedHeight = left.checkBalancedHeight()
            guard leftBalancedHeight != -1 else { return leftBalancedHeight }
        }
        if let right = right {
            rightBalancedHeight = right.checkBalancedHeight()
            guard rightBalancedHeight != -1 else { return rightBalancedHeight }
        }
        guard abs(leftBalancedHeight - rightBalancedHeight) <= 1 else { return -1 }
        return Swift.max(leftBalancedHeight, rightBalancedHeight) + 1
    }
}


/// Base Binary Search Tree protocol
public protocol BinarySearchTree: BinaryTree {
    func search(_ element: Element) -> Self?
}

/// Base BST search
extension BinarySearchTree {
    public func search(_ element: Element) -> Self? {
        switch element {
        case _ where element < self.element:
            return left?.search(element)
        case _ where element > self.element:
            return right?.search(element)
        default:
            return self
        }
    }
}

