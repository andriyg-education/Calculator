	//
//  GraphDrawler.swift
//  Calculator
//
//  Created by Andriy Gushuley on 14/09/15.
//  Copyright © 2015 andriyg. All rights reserved.
//

import UIKit

class GraphDrawler {
    init(function: ((Double) -> Double?)) {
        self.function = function
    }
    
    var color = UIColor.blueColor()
    
    var function: ((Double) -> Double?) = { $0 }
    
    func drawAxesInRect(bounds: CGRect, origin: CGPoint, pointsPerUnit: CGFloat)
    {
        CGContextSaveGState(UIGraphicsGetCurrentContext())
        color.set()
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var prevPoint: CGPoint?
        while x < bounds.width {
            let xval = (x-origin.x) / pointsPerUnit
            
            let yval = function(Double(xval))
            if let yval = yval {
                let y = origin.y - CGFloat(yval) * pointsPerUnit
                let point = CGPoint(x: x, y: y)
                print("Point \(point)")
                if prevPoint != nil {
                    path.addLineToPoint(point)
                } else {
                    path.moveToPoint(point)
                }
                prevPoint = point
            } else {
                prevPoint = nil
            }
            x = x + 0.5
        }
        path.moveToPoint(CGPoint(x: bounds.minX, y: origin.y))
        path.addLineToPoint(CGPoint(x: bounds.maxX, y: origin.y))
        path.moveToPoint(CGPoint(x: origin.x, y: bounds.minY))
        path.addLineToPoint(CGPoint(x: origin.x, y: bounds.maxY))
        path.stroke()
        CGContextRestoreGState(UIGraphicsGetCurrentContext())
    }
    
}
