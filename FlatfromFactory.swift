//
//  FlatfromFactory.swift
//  panda
//
//  Created by taojiang on 14-9-23.
//  Copyright (c) 2014年 taojiang. All rights reserved.
//

import Foundation
import SpriteKit

class FlatfromFactory:SKNode {
    
    let texture_l:SKTexture = SKTexture(imageNamed:"platform_l")
    let texture_r:SKTexture = SKTexture(imageNamed:"platform_r")
    let texture_m:SKTexture = SKTexture(imageNamed:"platform_m")
    
    var platfromNodes:[Flatfrom] = [];
    var sceneWidth:CGFloat = 0;
    var delegation:ProtocolManScene?;
    
    func createRandomFlatfrom() ->Void {
        let midNum:CGFloat = CGFloat(arc4random() % 4 + 1);
        let gap:CGFloat = CGFloat(arc4random() % 8 + 1);
        let x:CGFloat = sceneWidth + midNum * 50 + gap + 100;
        let y:CGFloat = CGFloat(arc4random() % 200 + 200);
        pushFlatfrom(Int(midNum),x: x,y: y);
        
    }
    
    //产生一个平台添加
    func pushFlatfrom(num:Int,x:CGFloat,y:CGFloat) -> Void
    {
        let flatfrom:Flatfrom = Flatfrom();
        flatfrom.position.x = x;
        flatfrom.position.y = y;
        addChild(flatfrom);

        let lt_sprite:SKSpriteNode = SKSpriteNode(texture: texture_l);
        let rt_sprite:SKSpriteNode = SKSpriteNode(texture: texture_r);
        
        var flat_from_nodes:[SKSpriteNode] = [lt_sprite];
        
        var i = 0;
        for i; i != num; i++ {
            let mt_sprite:SKSpriteNode = SKSpriteNode(texture: texture_m);
            flat_from_nodes.append(mt_sprite);
        }
        
        flat_from_nodes.append(rt_sprite);
        flatfrom.onCreate(flat_from_nodes);
        platfromNodes.append(flatfrom);
        delegation?.onGetData(x + flatfrom.width - sceneWidth);
    }
    
    func destorytrashy() {
        var i:Int = 0;
        var len:Int = platfromNodes.count;
        for i; i != len; {
            if platfromNodes[i].position.x <= -platfromNodes[i].width {
                platfromNodes.removeAtIndex(i);
                len = platfromNodes.count;
            } else {
                i++;
            }
        }
    }
    
    func move() ->Void {
        var i:Int = 0;
        var len:Int = platfromNodes.count;
        for i in i...len - 1 {
            platfromNodes[i].position.x -= delegation!.onGetSpeed();
            
            platfromNodes[i].updateFrame();
        }
    }
}
