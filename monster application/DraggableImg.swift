//
//  DraggableImg.swift
//  monster application
//
//  Created by Kersuzan on 25/10/2015.
//  Copyright © 2015 Kersuzan. All rights reserved.
//

import UIKit

class DraggableImg: UIImageView {
    
    var orinalPosition: CGPoint!
    var target: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Events handle
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        orinalPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // Careful : Because we use stack view, to get the position we need to write self.superview?.superview instead of self.superview
            let position = touch.locationInView(self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Check if the ended touch in on the target
        if let touch = touches.first, let target = target {
            
            let position = touch.locationInView(self.superview?.superview)
            
            if CGRectContainsPoint(target.frame, position) {
                
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDropped", object: nil))
            }
            
        }
        
        self.center = orinalPosition
    }
    
}
