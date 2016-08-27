/*:
 - example:
 [Binary Tree Zigzag Level Order Traversal](https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal)
 */
import Foundation

var tree = TreeNodeEnumTraversal(SequenceHelper.randomCharacterSequence(length: 14))

/*:
 * callout(Exercise):
 Given a binary tree, implement its zigzag level order traversal
 */

// See solution in the playground sources
tree.traversalStrategy = ZigzagOrderTraversalStrategy.self
showInLiveView(rootNode: tree)

/*:
 > You can see live view traversal visualisation via:
 
 ![Show Live View](showliveview.png)
 
 [Previous Page](@previous)
*/


