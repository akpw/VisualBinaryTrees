//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// A binary tree that can be visualized in a Playground / Xcode debugger
public protocol QuickLookableBinaryTree: BinaryTree, CustomPlaygroundQuickLookable {
    var quickLookView: (_ rootNode: Self) -> UIView { get }
}

/// CustomPlaygroundQuickLookable
extension QuickLookableBinaryTree {
    /// Playground quick look
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        let treeView = quickLookView(self)
        return PlaygroundQuickLook(reflecting: treeView)
    }

    /// Xcode debugger quick look
    public var quickLookObject: PlaygroundQuickLook?  {
        return customPlaygroundQuickLook
    }
    public func debugQuickLookObject() -> AnyObject? {
        return quickLookView(self)
    }
    
    /// Visualization as an image
    public var quickLookImage: UIImage? {
        let treeView = quickLookView(self)
        
        UIGraphicsBeginImageContextWithOptions(treeView.bounds.size, true, 0)
        defer { UIGraphicsEndImageContext() }
        
        treeView.drawHierarchy(in: treeView.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return image
    }
}

/// Default Visual Tree Config
extension QuickLookableBinaryTree {
    /// Configures visual tree representation
    public var quickLookView: (Self) -> UIView {
        // Default Tree View configuration
        return DefaultTreeDrawingConfig.configureTreeView
    }    
}
