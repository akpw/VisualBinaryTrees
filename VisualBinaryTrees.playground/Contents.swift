/*:

 ## Sample tree visualisations
 
 > This playground and its usage is described in details in the following [blog series](http://www.akpdev.com/articles/2016/08/26/BinaryTreesPlayground.html) -- keep tuned for more updates.
 
 */
// Sample reference type tree
let nTree: TreeNodeRef = [4,2,1,3,6,9,7,5,11,8,2]
print("Tree of height: \(nTree.height), with \(nTree.count) elements (\(isBalanced(nTree)))")

// Sample enum type tree
var chTree = TreeNodeEnumTraversal("TheQuickBrownFoxJumpsOvertheLazyDog".characters)

// Pluggable traversals 
print("\(chTree)")
chTree.traversalStrategy = LevelOrderTraversalStrategy.self
print("\(chTree)")


// Live View traversals visualization
let randomTree = TreeNodeEnumTraversal(SequenceHelper.randomCharacterSequence(length: 12))
chTree.traversalStrategy = LevelOrderTraversalStrategy.self
showInLiveView(rootNode: randomTree)






