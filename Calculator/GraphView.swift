//
//  GraphView.swift
//  Calculator
//
//  Created by Andriy Gushuley on 13/09/15.
//  Copyright © 2015 andriyg. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    @IBInspectable var scale: CGFloat = 2 { didSet { setNeedsDisplay() } }
    @IBInspectable var color: UIColor = UIColor.blackColor() {
        didSet {
            drawler.color = color
            graphDrawler.color = color
            setNeedsDisplay()
        }
    }
    
    var function: ((Double) -> Double?) = { $0 } {
        didSet {
            graphDrawler.function = function
        }
    }
    
    private let drawler: AxesDrawer = AxesDrawer()
    private let graphDrawler: GraphDrawler = GraphDrawler(function: { $0 })

    var graphCenter: CGPoint {
        return CGPoint(x: self.bounds.size.width / 2 + centerOffset.x, y: self.bounds.size.height / 2 + centerOffset.y)
    }
    
    override func drawRect(rect: CGRect) {
        let pointsPerUnit = min(bounds.size.height, bounds.size.width) / scale
        drawler.drawAxesInRect(bounds, origin: graphCenter, pointsPerUnit: pointsPerUnit)
        graphDrawler.drawAxesInRect(bounds, origin: graphCenter, pointsPerUnit: pointsPerUnit)
    }
    
    @IBInspectable var centerOffset: CGPoint = CGPoint.zero { didSet { setNeedsDisplay() } }
    
    func moveCenterFor(offset: CGPoint) {
        centerOffset = centerOffset + offset
    }

}

func +(x: CGPoint, y: CGPoint) -> CGPoint {
    return CGPoint(x: x.x + y.x, y: x.y + y.y)
}
