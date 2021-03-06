/*:
 - example:
  [Constructing a Binary Tree from in-order and post-order traversals](https://leetcode.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal)

 [Next Page](@next)
 
 [Previous Page](@previous)
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
 Given the `inOrder` and `postOrder` traversals, re-construct the originalTree
 */
// Solution:
// See `TreeBuilder` in this PlaygroundPage's sources.
// The tree quicklook shows what was constructed, so it can be visually compared with the originalTree
let reconstructedTree = TreeBuilder.buildTree(inOrder: inOrder, postOrder: postOrder)

// test
assert(originalTree == reconstructedTree)


/*:
  [Next Page](@next)
 
  [Previous Page](@previous)
 */

