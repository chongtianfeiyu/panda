//
//  GameSound.swift
//  panda
//
//  Created by taojiang on 14-10-2.
//  Copyright (c) 2014年 taojiang. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameSound: SKNode {
    
    let hitPlatfromAct:SKAction = SKAction.playSoundFileNamed("hit_platform.mp3", waitForCompletion: false)
    let hitAppleAct:SKAction = SKAction.playSoundFileNamed("hit.mp3",waitForCompletion: false);
    let lose:SKAction = SKAction.playSoundFileNamed("lose.mp3",waitForCompletion: false);
    var bgMusic:AVAudioPlayer?
    
    override init() {
        super.init();
    }
    
    //开始背景音乐
    func playBackground() -> Void {

        if bgMusic == nil {
            let NSURL = NSBundle.mainBundle().URLForResource("apple", withExtension: "mp3")
            bgMusic = AVAudioPlayer(contentsOfURL: NSURL, error: nil)
            bgMusic!.numberOfLoops = -1;
            bgMusic!.prepareToPlay();
        }
        bgMusic!.play();
    }
    
    //停止背景音乐
    func stopBackground() -> Void {
        bgMusic!.stop();
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    func playJump() {
        runAction(hitPlatfromAct);
    }
    
    func playScroll() {
        runAction(hitPlatfromAct);
    }
    
    func playDied() {
        runAction(lose)
    }
}
