import Foundation

/// Solution: constructing a Binary Tree from in-order and post-order traversals
public struct TreeBuilder {
    public static func buildTree<Element: Comparable>(inOrder: [Element],
                                       postOrder: [Element]) -> TreeNodeRef<Element>? {
        return buildTree(inOrder: inOrder[inOrder.startIndex..<inOrder.endIndex],
                               postOrder: postOrder[postOrder.startIndex..<postOrder.endIndex])
    }
    
    public static func buildTree<Element: Comparable>(inOrder: ArraySlice<Element>,
                                       postOrder: ArraySlice<Element>) -> TreeNodeRef<Element>? {
        // base case
        guard inOrder.endIndex > inOrder.startIndex,
            postOrder.endIndex > postOrder.startIndex,
            let rootElement = postOrder.last,
            let rootIdx = inOrder.index(of: rootElement) else { return nil }
        
        // The right and the left subtrees in-order slices
        let inOrderRight = inOrder[rootIdx.advanced(by: 1)..<inOrder.endIndex]
        let inOrderLeft = inOrder[inOrder.startIndex..<rootIdx]
        
        // The right and the left subtrees post-order slices
        let postOrderRightStartIdx = postOrder.endIndex.advanced(by: -(inOrderRight.count + 1))
        let postOrderRight = postOrder[postOrderRightStartIdx..<postOrder.endIndex.advanced(by: -1)]
        let postOrderLeft = postOrder[postOrder.startIndex..<postOrderRightStartIdx]
        
        let leftTree = buildTree(inOrder: inOrderLeft, postOrder: postOrderLeft)
        let rightTree = buildTree(inOrder: inOrderRight, postOrder: postOrderRight)
        
        let tree = TreeNodeRef(rootElement)
        tree.left = leftTree
        tree.right = rightTree
        
        return tree
    }
}










