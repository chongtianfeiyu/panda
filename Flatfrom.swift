//
//  Flatfrom.swift
//  panda
//
//  Created by taojiang on 14-9-23.
//  Copyright (c) 2014 taojiang. All rights reserved.
//

import Foundation
import SpriteKit


class Flatfrom:SKNode {
    
    //台子的宽度
    var width:CGFloat = 0;
    
    var isTrap:Bool = false;
    var gravity:CGFloat = 0;
    
    func onCreate(nodes:[SKSpriteNode]) {
        var i:Int = 0;
        var len:Int = nodes.count;
        for i; i != len; i++ {
            let spr_latefrom:SKSpriteNode = nodes[i];
            spr_latefrom.anchorPoint = CGPoint(x: 0,y: 0.9)
            addChild(spr_latefrom);
            spr_latefrom.position.x = width;
            width += spr_latefrom.size.width;
        }
        
        if len == 3  {
            let randomNum:UInt32 = arc4random() % 100;
            if randomNum % 2 > 0 {
                isTrap = true;
            }
        }
        
        physicsBody = SKPhysicsBody(rectangleOfSize:CGSizeMake(width, 10),center:CGPoint(x: width / 2, y: 0))
        physicsBody.categoryBitMask = PhysicsContactType.platfrom;
        physicsBody.fieldBitMask = PhysicsContactType.scene | PhysicsContactType.platfrom;
        physicsBody.dynamic = false;
        physicsBody.allowsRotation = false;
        physicsBody.restitution = 0;
    }
    
    func triggerTrap() ->Void {
        gravity = -10;
    }
    
    func updateFrame() ->Void {
        position.y += gravity;
    }
}
