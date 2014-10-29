//
//  AppleFactory.swift
//  panda
//
//  Created by taojiang on 14-10-15.
//  Copyright (c) 2014年 taojiang. All rights reserved.
//

import UIKit
import SpriteKit;

class AppleFactory: SKNode {
    
    let appleTexture:SKTexture = SKTexture(imageNamed: "apple");
    var apples:[SKSpriteNode?] = [];
    var nsTime:NSTimer?;
    var sceneWidth:CGFloat = 0.0;
    var theY:CGFloat = 0.0;
    override init() {
        super.init();
    }
    
    func onInit(sw:CGFloat,y:CGFloat) ->Void {
        if nsTime == nil {
            nsTime = NSTimer.scheduledTimerWithTimeInterval(0.2,target: self, selector: "onInternalHandler", userInfo: nil?, repeats: true)
        }
        sceneWidth = sw;
        theY = y;
    }
    
    func onInternalHandler() ->Void {
        let randomNum = arc4random() % 10
        if randomNum > 8 {
            var apple:SKSpriteNode? = SKSpriteNode(texture: appleTexture);
            if apple != nil {
                apple!.physicsBody = SKPhysicsBody(rectangleOfSize: appleTexture.size());
                apple!.physicsBody!.categoryBitMask = PhysicsContactType.apple;
                apple!.physicsBody!.restitution = 0.0;
                apple!.physicsBody!.dynamic = false;
                apple!.anchorPoint = CGPointMake(0,0);
                apple!.zPosition = 40;
                apple!.position = CGPointMake(sceneWidth + apple!.frame.size.width,theY - 150)
                apples.append(apple!)
                addChild(apple!)
            }
        }
    }
    
    func move(speed:CGFloat) ->Void {
        for apple in apples {
            apple!.position.x -= speed;
        }
        
        if apples.count > 0 && apples[0]!.position.x <= -20 {
            apples[0]!.removeFromParent();
            apples.removeAtIndex(0);
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

