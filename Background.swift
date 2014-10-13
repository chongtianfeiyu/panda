//
//  Background.swift
//  panda
//
//  Created by taojiang on 14-9-25.
//  Copyright (c) 2014年 taojiang. All rights reserved.
//

import Foundation
import SpriteKit

class Background:SKNode {
    
    //移动速度
    var moveSpeed:CGFloat = 0;
    var bgNodes:[SKSpriteNode] = [];
    var frontNodes:[SKSpriteNode] = [];
    
    var rectSize:CGSize? = nil;
    
    override init() {
        super.init()
        
        
        let bgTexture:SKTexture = SKTexture(imageNamed: "background_f1");
        let frontTexture:SKTexture = SKTexture(imageNamed: "background_f0");
        
        var i:Int = 0;
        var len:Int = 2;
        for i in i...len - 1 {
            let bgSprite:SKSpriteNode = SKSpriteNode(texture: bgTexture);
            bgSprite.anchorPoint = CGPoint(x: 0, y: 1)
            bgSprite.position.x = CGFloat(bgSprite.size.width * CGFloat(i));
            bgNodes.append(bgSprite);
            addChild(bgSprite);
        }
        
        len = 3;
        for i in i...len - 1 {
            let frontSprite:SKSpriteNode = SKSpriteNode(texture:frontTexture);
            frontSprite.position.x = CGFloat(frontSprite.size.width * CGFloat(i));
            frontSprite.anchorPoint = CGPoint(x: 0, y: 1)
            frontNodes.append(frontSprite);
            addChild(frontSprite);
        }
        
        rectSize = CGSize(width: bgTexture.size().width, height: bgTexture.size().height)
        
    }
    


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func move(speed:CGFloat) {
        moveSpeed = speed;
        
        //移动背景图
        for node in bgNodes {
            node.position.x -= moveSpeed / 4;
        }
        if bgNodes[0].position.x <= -bgNodes[0].size.width {
            var i:Int = 0;
            var len:Int = bgNodes.count;
            for i in i...len - 1 {
                bgNodes[i].position.x = CGFloat(bgNodes[0].size.width * CGFloat(i));
            }
        }
        
        //移动近景图
        for node in frontNodes {
            node.position.x -= moveSpeed;
        }
        if frontNodes[0].position.x <= -frontNodes[0].size.width {
            var i:Int = 0;
            var len:Int = frontNodes.count;
            for i in i...len - 1 {
                frontNodes[i].position.x = CGFloat(frontNodes[0].size.width * CGFloat(i));
            }
        }
        
        
    }
}
