//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// AppDelegate for the Sample App
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        window = {
            $0.rootViewController = configureTopViewController()
            $0.makeKeyAndVisible()
            return $0
        }( UIWindow(frame: UIScreen.main.bounds) )
        return true
    }    
}

extension AppDelegate {
    /// Configures top level view controller and its dependencies
    ///
    /// - returns: TreeViewController initialised with a random tree
    func configureTopViewController() -> UIViewController {
        let nTree: TreeNodeRef = [1,2,3,4,5,6,7,8]
        nTree.traversalStrategy = LevelOrderTraversalStrategy.self
        print("Tree of height: \(nTree.height), with \(nTree.count) elements: \(nTree)")
        
        let enumTree: TreeNodeEnum = [1,2,3,4,5,6,7,8]
        print("Tree of height: \(enumTree.height), with \(enumTree.count) elements")
        
        var enumTraversalTree: TreeNodeEnumTraversal = [1,2,3,4,5,6,7,8]
        enumTraversalTree.traversalStrategy = PostOrderTraversalStrategy.self
        print("Tree of height: \(enumTraversalTree.height), with \(enumTraversalTree.count) elements: \(enumTraversalTree)")
        
        var randomTree = TreeNodeEnumTraversal(SequenceHelper.randomCharacterSequence(length: 26))
        randomTree.traversalStrategy = ZigzagOrderTraversalStrategy.self

        let _ = randomTree.quickLookImage
        
        let layoutBuilder = TreeLayoutBuilderReingold()
        let treeView = DefaultTreeDrawingConfig.configureTreeView(rootNode: randomTree,
                                                                  layoutBuilder: layoutBuilder,
                                                                  visualizeTraversal: true)
        // Top-level view controller
        let viewController = TreeViewController()
        viewController.inject(treeView)        
        return viewController
    }
}


