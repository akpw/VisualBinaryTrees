/*:
 - example:
  [Constructing a Binary Tree from in-order and post-order traversals](https://leetcode.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal)
 
 [Next Page](@next) 
 */
import Foundation

let originalTree = TreeNodeRef(SequenceHelper.randomCharacterSequence(length: 14))
let inOrder = originalTree.map{$0.element}
print("Input in-order: \(inOrder)")
originalTree.traversalStrategy = PostOrderTraversalStrategy.self
let postOrder = originalTree.map{$0.element}
print("Input post-order: \(postOrder)")

/*:
 * callout(Exercise):
 Given the `inOrder` and `postOrder` arrays, re-construct the originalTree.
 */
// See solution in this playground page's sources
// The tree quicklook helps immediately see what was constructed, and compare it with the originalTree
let reconstructedTree = TreeBuilder.buildTree(inOrder: inOrder, postOrder: postOrder)

// test
assert(originalTree == reconstructedTree)


//: [Previous Page](@previous)

