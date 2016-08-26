//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// Default Drawing Sizes
fileprivate enum DrawingSizes {
    enum Grid {
        static let GridUnitSize: CGFloat = 81.0
        static let GridLineWidth: CGFloat = 0.75
    }
    static let TreeLineWidth: CGFloat = 3
    static let TreeNodeFontSize: CGFloat = 35.0
}

/// Default Drawing Colors
fileprivate enum DrawingColors {
    static let BackGroundColor = UIColor(white: 0.88, alpha: 1.0)
    static let TreeNodeColor = UIColor(red: 0.41, green: 0.00, blue: 0.74, alpha: 1)
    static let TreeLineColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    static let GridColor = UIColor(white: 0.5614, alpha: 1.0)
}

/// Provides default tree drawing configuration 
public struct DefaultTreeDrawingConfig {
    public static func configureTreeView<Node: BinaryTree>(rootNode: Node) -> UIView {
        let layoutBuilder = TreeLayoutBuilderReingold()
        return configureTreeView(rootNode: rootNode,
                                 layoutBuilder: layoutBuilder,
                                 visualizeTraversal: false)
    }

    public static func configureTreeView<Node: BinaryTree>(rootNode: Node,
                                                           layoutBuilder: TreeLayoutBuilder,
                                                           visualizeTraversal: Bool) -> UIView {
        let drawingAttributes =
            TreeDrawingAttributes(gridUnitSize: DrawingSizes.Grid.GridUnitSize,
                                  gridLineWidth: DrawingSizes.Grid.GridLineWidth,
                                  treeLineWidth: DrawingSizes.TreeLineWidth,
                                  treeFontSize: DrawingSizes.TreeNodeFontSize,
                                  gridColor: DrawingColors.GridColor,
                                  treeNodeColor: DrawingColors.TreeNodeColor,
                                  treeLineColor: DrawingColors.TreeLineColor,
                                  backGroundColor: DrawingColors.BackGroundColor)
        let treeDrawing = TreeDrawing(rootNode: rootNode,
                                      drawingAttributes: drawingAttributes,
                                      layoutBuilder: layoutBuilder,
                                      visualizeTraversal: visualizeTraversal)
        let treeRenderer = CoreGraphicsTreeRenderer(frame: CGRect(x: 0, y: 0,
                                                                  width: treeDrawing.width,
                                                                  height: treeDrawing.height ))
        treeRenderer.view.backgroundColor = drawingAttributes.backGroundColor
        treeRenderer.draw = treeDrawing.draw
        return treeRenderer.view
    }
}


