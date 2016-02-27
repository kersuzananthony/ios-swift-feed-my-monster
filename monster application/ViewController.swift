//
//  ViewController.swift
//  monster application
//
//  Created by Kersuzan on 25/10/2015.
//  Copyright © 2015 Kersuzan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var penaltyImg1: UIImageView!
    @IBOutlet var penaltyImg2: UIImageView!
    @IBOutlet var penaltyImg3: UIImageView!
    @IBOutlet var heartImg: DraggableImg!
    @IBOutlet var foodImg: DraggableImg!
    @IBOutlet var monsterImg: MonsterImg!
    
    var timer: NSTimer!
    var penalties: Int!
    var monsterHappy: Bool!
    var monsterIsDead: Bool!
    var currentItem: UInt32!
    
    var backgroundMusic: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    
    let OPAQUE: CGFloat = 1.0
    let TRANSPARENT: CGFloat = 0.2
    let MAX_PENALTIES: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
        
        heartImg.target = monsterImg
        foodImg.target = monsterImg
        
        disableUserInteractionOnImages()
        
        // Listen for onTargetDropped notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try backgroundMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            
            backgroundMusic.prepareToPlay()
            backgroundMusic.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        
        startTimer()
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameStatus", userInfo: nil, repeats: true)
        
    }

    func changeGameStatus() {
        
        if !monsterHappy {
            penalties!++
            sfxSkull.play()
            
            changePenaltiesImagesOpacity()
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        // Only if monster is not dead
        if !monsterIsDead {
            let rand = arc4random_uniform(2)
            
            if rand == 0 {
                // Current item is food
                foodImg.alpha = OPAQUE
                foodImg.userInteractionEnabled = true
                
                heartImg.alpha = TRANSPARENT
                heartImg.userInteractionEnabled = false
            } else {
                // Current item is heart
                foodImg.alpha = TRANSPARENT
                foodImg.userInteractionEnabled = false
                
                heartImg.alpha = OPAQUE
                heartImg.userInteractionEnabled = true
            }
            
            currentItem = rand
            
            

        }
        monsterHappy = false
        
    }
    
    func changePenaltiesImagesOpacity() -> Void {
        // Change penalty Images alpha
        if penalties == 1 {
            penaltyImg1.alpha = OPAQUE
            penaltyImg2.alpha = TRANSPARENT
            penaltyImg3.alpha = TRANSPARENT
        } else if penalties == 2 {
            penaltyImg2.alpha = OPAQUE
            penaltyImg3.alpha = TRANSPARENT
        } else if penalties == 3 {
            penaltyImg3.alpha = OPAQUE
        } else if penalties == 0 {
            penaltyImg1.alpha = TRANSPARENT
            penaltyImg2.alpha = TRANSPARENT
            penaltyImg3.alpha = TRANSPARENT
        }
    }
    
    func startGame() {
        self.monsterIsDead = false
        self.monsterHappy = true
        self.monsterImg.playLiveAnimation()
        self.startTimer()
        self.penalties = 0
        self.changePenaltiesImagesOpacity()

    }
    
    func gameOver() {
        sfxDeath.play()
        monsterImg.playDeathAnimation()
        timer.invalidate()
        monsterIsDead = true
        disableUserInteractionOnImages()
        
        // Make an alert for restarting the game
        let alert = UIAlertController(title: "Game over", message: "Do you want to restart the game?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                self.startGame()
        })
        
        
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    func itemDroppedOnCharacter(notification: AnyObject) {
        // Invalidate the timer
        timer.invalidate()
        monsterHappy = true
        
        if penalties > 0 {
            penalties!--
        }
        
        changePenaltiesImagesOpacity()
        
        disableUserInteractionOnImages()
        
        if currentItem == 0 {
            // Current is food
            sfxBite.play()
        } else {
            // Current is heart
            sfxHeart.play()
        }
        
        startTimer()
    }
    
    func disableUserInteractionOnImages() -> Void {
        foodImg.alpha = TRANSPARENT
        foodImg.userInteractionEnabled = false
        heartImg.alpha = TRANSPARENT
        heartImg.userInteractionEnabled = false
    }
    
}

