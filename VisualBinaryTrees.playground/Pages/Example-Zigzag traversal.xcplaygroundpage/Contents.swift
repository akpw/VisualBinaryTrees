/*:
 - example:
 [Binary Tree Zigzag Level Order Traversal](https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal)

 [Previous Page](@previous)
 */

import Foundation

var tree = TreeNodeEnumTraversal(SequenceHelper.randomCharacterSequence(length: 14))

/*:
 * callout(Exercise):
 Given a binary tree, implement Zigzag-order traversal
 */
// ...
// ...

// Solution:
// See `ZigzagOrderTraversalStrategy` in the Playground's sources
tree.traversalStrategy = ZigzagOrderTraversalStrategy.self

// Now let's check this traversal in the Live View:
showInLiveView(rootNode: tree)

/*:
 > In Xcode, you can see live view traversal visualisations via:
 
 ![Show Live View](showliveview.png)
*/
/*:
 [Previous Page](@previous)
*/


