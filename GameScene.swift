//
//  GameScene.swift
//  黄欢快跑
//
//  Created by taojiang on 14-9-22.
//  Copyright (c) 2014年 taojiang. All rights reserved.
//
//

import SpriteKit

class GameScene: SKScene,ProtocolManScene,SKPhysicsContactDelegate {
    
    //熊猫黄欢
    lazy var huanghuang:panda = panda();
    //平台创建工厂
    lazy var flatfrom_factory:FlatfromFactory = FlatfromFactory();
    //背景，远景，近景
    lazy var bg:Background = Background();
    //二段跳跃时的动画效果
    var jeSprite:SKSpriteNode?
    //游戏的音乐
    lazy var sound:GameSound = GameSound();
    //得分显示
    lazy var scoreLab = SKLabelNode(fontNamed:"Chalkduster")
    //苹果数量显示
    lazy var appLab = SKLabelNode(fontNamed:"Chalkduster")
    
    var appleNum = 0                        //吃的苹果数量
    var lastDis     :CGFloat = 0.0;         //最后平台在场景中是位置，用于验证新平台的创建
    var dinstance   :CGFloat = 0.0;         //当前已经跑了的距离
    var jumpStart   :CGFloat = 0.0;         //起跳点
    var jumpEnd     :CGFloat = 0.0;         //落地
    var moveSpeed   :CGFloat = 15.0;        //移动的速度
    let maxSpeed    :CGFloat = 50.0;        //最大移动速度
    let PANDNA_PS   :CGFloat = 200;         //熊猫的位置

    //skView
    var skView:SKView?
    
    override func didMoveToView(view: SKView) {
    
        
        let bgColor:UIColor = UIColor(red: 113 / 255, green: 197 / 255, blue: 207 / 255, alpha: 1)
        backgroundColor = bgColor;
        
        bg.position = CGPointMake(0,bg.rectSize!.height + 100);
        addChild(bg);
        
        addChild(flatfrom_factory);
        flatfrom_factory.pushFlatfrom(2, x: 50, y: 300);
        flatfrom_factory.delegation = self;
        flatfrom_factory.sceneWidth = frame.size.width;
        
        physicsWorld.contactDelegate = self;
        physicsWorld.gravity = CGVector(0,-5);
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame);
        physicsBody.categoryBitMask = PhysicsContactType.scene;
        physicsBody.dynamic = false;
        
        sound.playBackground();
        skView = view;
        
        scoreLab.position = CGPointMake(20, frame.size.height - 80);
        scoreLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left;
        scoreLab.text = "ran 0 km";
        addChild(scoreLab);
        
        gameStar();
    }
    
    //游戏开始
    func gameStar() {
        skView!.paused = false;
        addChild(huanghuang);
        dinstance = 0.0;
        //黄欢的初始位置
        huanghuang.position = CGPoint(x:PANDNA_PS, y: 500);
    }
    
    //游戏结束
    func gameEnd() {
        skView!.paused = true;
        //sound.stopBackground();
        huanghuang.removeFromParent();
    }
    
    
    //开始碰撞检测
    func didBeginContact(contact: SKPhysicsContact!) {
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (PhysicsContactType.panda | PhysicsContactType.platfrom) {
            huanghuang.run();
            jumpEnd = huanghuang.position.y;
            
            let distValue = jumpEnd - jumpStart;
            if abs(distValue) >= 150 {
                huanghuang.roll();
            }
            
            var contactPlatfrom:Flatfrom?;
            if contact.bodyA.categoryBitMask == PhysicsContactType.platfrom {
                contactPlatfrom = contact.bodyA.node as? Flatfrom;
            }
            else if contact.bodyB.categoryBitMask == PhysicsContactType.platfrom {
                contactPlatfrom = contact.bodyB.node as? Flatfrom;
            }
            
            if contactPlatfrom != nil {
                if contactPlatfrom!.isTrap {
                    contactPlatfrom!.triggerTrap();
                }
            }
            
        }
        
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (PhysicsContactType.panda | PhysicsContactType.scene) {
            println("game over");
            gameEnd();
        }
        
    }
    
    //碰撞离开
    func didEndContact(contact:SKPhysicsContact) {
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (PhysicsContactType.panda | PhysicsContactType.platfrom) {
            jumpStart = huanghuang.position.y;
            //如果当前的位置小于200的时候，复位位子
            if huanghuang.position.x < PANDNA_PS {
                huanghuang.physicsBody.velocity = CGVector(PANDNA_PS,0);
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if(huanghuang.status == Status.jump) {
            addedJumpEffect()
            jumpStart = huanghuang.position.y;
        }
        huanghuang.jump();
    }
   
    func addedJumpEffect() -> Void {
        
        if jeSprite == nil {
            let texture:SKTexture? = huanghuang.textureAtlas[Status.jump2]?.first
            jeSprite = SKSpriteNode(texture:texture)
        }
        
        addChild(jeSprite!);
        jeSprite!.removeAllActions();
        jeSprite!.position = CGPoint(x: huanghuang.position.x,y: huanghuang.position.y + 3);
        jeSprite!.runAction(SKAction.animateWithTextures(huanghuang.textureAtlas[Status.jump2], timePerFrame: 1 / 16), completion: { () -> Void in
            self.jeSprite!.removeFromParent();
        })
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        lastDis -= moveSpeed;
        dinstance += moveSpeed;
        
        if lastDis <= 0 {
            flatfrom_factory.createRandomFlatfrom();
        }
        
        scoreLab.text = "run \(Int(round(dinstance / 100))) km";
        
        flatfrom_factory.move();
        flatfrom_factory.destorytrashy();
        
        bg.move(moveSpeed / 5)
        /* Called before each frame is rendered */
    }
    
    func onGetData(dist: CGFloat) {
        lastDis = dist;
    }
    
    func onGetSpeed() -> CGFloat {
        return moveSpeed;
    }
    
}

protocol ProtocolManScene {
    func onGetData(dist:CGFloat)
    func onGetSpeed() -> CGFloat;
}

//物理碰撞的类型
struct PhysicsContactType {
    static var scene : UInt32{
    return 1 << 0;
    }
    
    static var panda:UInt32{
    return 1 << 1;
    }
    
    static var platfrom:UInt32{
    return 1 << 2;
    }
    
    static var apple:UInt32{
    return 1 << 3;
    }
}

