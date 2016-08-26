//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

/// Base Layout Builders protocol
public protocol TreeLayoutBuilder {
    mutating func buildLayout<Node: BinaryTree>
                            (rootNode: Node, gridUnitSize: CGFloat) -> TreeLayout<Node>
}







