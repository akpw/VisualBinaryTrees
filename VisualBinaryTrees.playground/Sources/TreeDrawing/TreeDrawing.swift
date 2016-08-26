//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit
import CoreGraphics

/// Customizable Tree Drawing Attributes
public struct TreeDrawingAttributes {
    var gridUnitSize: CGFloat,  gridLineWidth: CGFloat
    var treeLineWidth: CGFloat, treeFontSize: CGFloat
    var gridColor: UIColor,     treeNodeColor: UIColor, treeLineColor: UIColor
    var backGroundColor: UIColor
}

/// Draws Tree Layout model built by specified TreeLayoutBuilder,
/// using DrawingState machine to manage states
public final class TreeDrawing<Node: BinaryTree>: Drawable {
    public var width: CGFloat { return treeLayout.layoutWidth  }
    public var height: CGFloat { return treeLayout.layoutHeight }
    
    public init(rootNode: Node,
                drawingAttributes: TreeDrawingAttributes,
                layoutBuilder: TreeLayoutBuilder,
                visualizeTraversal: Bool) {
        self.drawingAttributes = drawingAttributes

        var layoutBuilder = layoutBuilder
        treeLayout = layoutBuilder.buildLayout(rootNode: rootNode,
                                                      gridUnitSize: drawingAttributes.gridUnitSize)
        if treeLayout.traversalStrategy == nil {
            self.visualizeTraversal = false
           treeLayout.traversalStrategy = InOrderTraversalStrategy.self
        } else {
            self.visualizeTraversal = visualizeTraversal
        }
        drawingState = .ready
    }
    
    public func draw(_ renderer: Renderer) {
        drawGrid(renderer)
        drawTreeNodes(renderer)
        drawTreeLines(renderer)
        if visualizeTraversal { visualizeTraversal(renderer) }
    }
    
    // MARK: - Private
    private var visualizeTraversal: Bool
    private func drawGrid(_ renderer: Renderer) {
        drawingState = drawingState.toDrawingGrid(renderer, drawingAttributes: drawingAttributes)
        let grid = Grid(bounds: CGRect(x: 0, y: 0, width: width, height: height),
                        gridUnitSize: drawingAttributes.gridUnitSize,
                        lineWidth: drawingAttributes.gridLineWidth)
        grid.draw(renderer)
        drawingState = drawingState.toDoneDrawingGrid()
    }
    
    private func drawTreeNodes(_ renderer: Renderer) {
        drawingState = drawingState.toDrawingTreeNodes(renderer, drawingAttributes: drawingAttributes)
        for layout in treeLayout {
            drawNode(layout)
        }
        drawingState = drawingState.toDoneDrawingTreeNodes()
    }
    private func drawTreeLines(_ renderer: Renderer) {
        drawingState = drawingState.toDrawingTreeLines(renderer, drawingAttributes: drawingAttributes)
        for layout in treeLayout {
            if let left = layout.left {
                drawLine(fromNode: layout, toNode: left)
            }
            if let right = layout.right {
                drawLine(fromNode: layout, toNode: right)
            }
        }
        drawingState = drawingState.toDoneDrawingTreeLines()
    }
    
    private func visualizeTraversal(_ renderer: Renderer) {
        var keyRects = [CGRect]()
        for layout in treeLayout {
            keyRects.append(layout.boundingRect)
        }
        renderer.renderTraversal(at: keyRects)
    }
    
    private func drawNode(_ node: TreeLayout<Node>) {
        guard case let DrawingState.drawingTreeNodes(renderer) = drawingState else { return }
        let strValue = String(describing: node.element)
        renderer.renderText(strValue, fontSize: drawingAttributes.treeFontSize,
                            fontColor: drawingAttributes.treeNodeColor,
                            inBoundingRect: node.boundingRect)
    }
    private func drawLine(fromNode from: TreeLayout<Node>,
                          toNode to: TreeLayout<Node>) {
        guard case let DrawingState.drawingTreeLines(renderer) = drawingState else { return }
        renderer.renderLine(from: from.childLineAnchor, to: to.parentLineAnchor)
    }
    
    private var treeLayout: TreeLayout<Node>
    private let drawingAttributes: TreeDrawingAttributes
    private var drawingState: DrawingState
}

/// Drawing States
///
/// - ready:                ready for drawing
/// - drawingGrid:          drawing (optional) grid
/// - doneDrawingGrid:      done drawing (optional) grid
/// - drawingTreeNodes:     drawing tree nodes
/// - doneDrawingTreeNodes: done drawing tree nodes
/// - drawingTreeLines:     drawing tree lines
/// - doneDrawingTreeLines: done drawing tree lines
enum DrawingState {
    case ready
    case drawingGrid(Renderer)
    case doneDrawingGrid
    case drawingTreeNodes(Renderer)
    case doneDrawingTreeNodes
    case drawingTreeLines(Renderer)
    case doneDrawingTreeLines
    
    // Grid drawing states
    func toDrawingGrid(_ renderer: Renderer, drawingAttributes: TreeDrawingAttributes) -> DrawingState {
        switch self {
        case .ready, .doneDrawingTreeNodes, .doneDrawingTreeLines:
            renderer.configureLine(color: drawingAttributes.gridColor,
                                   width: drawingAttributes.gridLineWidth,
                                   dotted: false)
            return .drawingGrid(renderer)
        case .drawingGrid:
            return self
        default:
            fatalError("Non valid attempt of transition from \(self) to .DrawingGrid")
        }
    }
    func toDoneDrawingGrid() -> DrawingState {
        switch self {
        case .drawingGrid(let renderer):
            renderer.strokePath()
            return .doneDrawingGrid
        default:
            fatalError("Non valid attempt of transition from \(self) to .toDoneDrawingGrid")
        }
    }
    
    // Nodes drawing states
    func toDrawingTreeNodes(_ renderer: Renderer, drawingAttributes: TreeDrawingAttributes) -> DrawingState {
        switch self {
        case .ready, .doneDrawingGrid, .doneDrawingTreeLines:
            return .drawingTreeNodes(renderer)
        case .drawingTreeNodes:
            return self
        default:
            fatalError("Non valid attempt of transition from \(self) to .toDrawingTreeNodes")
        }
    }
    func toDoneDrawingTreeNodes() -> DrawingState {
        switch self {
        case .drawingTreeNodes(let renderer):
            renderer.strokePath()
            return .doneDrawingTreeNodes
        default:
            fatalError("Non valid attempt of transition from \(self) to .toDoneDrawingTreeNodes")
        }
    }
    
    // Tree Lines drawing states
    func toDrawingTreeLines(_ renderer: Renderer, drawingAttributes: TreeDrawingAttributes) -> DrawingState {
        switch self {
        case .ready, .doneDrawingGrid, .doneDrawingTreeNodes:
            renderer.configureLine(color: drawingAttributes.treeLineColor,
                                   width: drawingAttributes.treeLineWidth,
                                   dotted: true)
            return .drawingTreeLines(renderer)
        case .drawingTreeLines:
            return self
        default:
            fatalError("Non valid attempt of transition from \(self) to .toDrawingTreeLines")
        }
    }
    func toDoneDrawingTreeLines() -> DrawingState {
        switch self {
        case .drawingTreeLines(let renderer):
            renderer.strokePath()
            return .doneDrawingTreeLines
        default:
            fatalError("Non valid attempt of transition from \(self) to .toDoneDrawingTreeLines")
        }
    }
}


