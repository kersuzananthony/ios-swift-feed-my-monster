//
//  MonsterImg.swift
//  monster application
//
//  Created by Kersuzan on 25/10/2015.
//  Copyright © 2015 Kersuzan. All rights reserved.
//

import UIKit

class MonsterImg: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playLiveAnimation()
    }
    
    func playLiveAnimation() {
        
        self.image = UIImage(named: "idle1.png")
        
        var imgArray: [UIImage] = [UIImage]()
        
        self.animationImages = nil
        
        for var i = 1; i <= 4; i++ {
            let image = UIImage(named: "idle\(i).png")
            imgArray.append(image!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "dead5.png")
        
        var imgArray: [UIImage] = [UIImage]()
        
        self.animationImages = nil
        
        for var i = 1; i <= 5; i++ {
            let image = UIImage(named: "dead\(i).png")
            imgArray.append(image!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 1.0
        self.animationRepeatCount = 1
        self.startAnimating()
        
    }
    
    
}
