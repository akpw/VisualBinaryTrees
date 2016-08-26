//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import PlaygroundSupport

public func showInLiveView<Node: BinaryTree>(rootNode: Node){
    let layoutBuilder = TreeLayoutBuilderReingold()
    let treeView = DefaultTreeDrawingConfig.configureTreeView(rootNode: rootNode,
                                                              layoutBuilder: layoutBuilder,
                                                              visualizeTraversal: true)
    let treeVC = TreeViewController()
    treeVC.inject(treeView)
    PlaygroundPage.current.liveView = treeVC
}





