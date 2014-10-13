//
//  panda.swift
//  panda
//
//  Created by taojiang on 14-9-22.
//  Copyright (c) 2014 taojiang. All rights reserved.
//
import SpriteKit

enum Status:Int {
    case run=1,jump=2,jump2=3,roll=4;
    
}

class panda:SKSpriteNode
{
    let runAtlas = SKTextureAtlas(named:"run.atlas");
    let jumpAtlas = SKTextureAtlas(named:"jump.atlas");
    let jumpeffectAtlas = SKTextureAtlas(named:"jump_effect.atlas");
    let rollAtlas = SKTextureAtlas(named:"roll.atlas");
    var status:Status = Status.run;
    let textureAtlas:Dictionary<Status,[SKTexture]> = Dictionary();
    
    override init()
    {
        
        
        let texture = runAtlas.textureNamed("panda_run_01");
        let size:CGSize = texture.size();
        var frames:[SKTexture] = [];
        var textureName:String = "";
        var frameTexture:SKTexture?;
        super.init(texture: texture, color: UIColor.whiteColor(), size: size);
        
        
        physicsBody = SKPhysicsBody(rectangleOfSize: texture.size());
        physicsBody.dynamic = true;
        physicsBody.allowsRotation = false;
        physicsBody.restitution = 0;
        physicsBody.categoryBitMask = PhysicsContactType.panda;
        physicsBody.contactTestBitMask = PhysicsContactType.scene | PhysicsContactType.platfrom;
        physicsBody.collisionBitMask = PhysicsContactType.platfrom;
        
        for var i = 1; i <= runAtlas.textureNames.count; i++ {
            textureName = String(format:"panda_run_%.2d",i)
            frameTexture = runAtlas.textureNamed(textureName)
            if frameTexture != nil {
                frames.append(frameTexture!);
            }
        }
        textureAtlas[Status.run] = frames;
        
        frames = [];
        for var i = 1 ;i <= jumpAtlas.textureNames.count; i++ {
            textureName = String(format:"panda_jump_%.2d",i);
            frameTexture = jumpAtlas.textureNamed(textureName);
            if frameTexture != nil {
                frames.append(frameTexture!);
            }
        }
        textureAtlas[Status.jump] = frames;
        
        frames = [];
        for var i = 1; i <= jumpeffectAtlas.textureNames.count; i++ {
            textureName = String(format:"jump_effect_%.2d",i);
            frameTexture = jumpeffectAtlas.textureNamed(textureName);
            if frameTexture != nil {
                frames.append(frameTexture!);
            }
        }
        textureAtlas[Status.jump2] = frames;
        
        frames = [];
        for var i = 1; i <= rollAtlas.textureNames.count; i++ {
            textureName = String(format:"panda_roll_%.2d",i);
            frameTexture = rollAtlas.textureNamed(textureName);
            if frameTexture != nil {
                frames.append(frameTexture!);
            }
        }
        textureAtlas[Status.roll] = frames;
        run();
    }
    
    func run() {
        removeAllActions();
        status = .run;
        runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textureAtlas[Status.run], timePerFrame: 1/16)));
    }
    
    func jump() {
        removeAllActions();
        if status != Status.jump2 {
            physicsBody.velocity = CGVectorMake(0,450);
            if status == Status.jump {
                runAction(SKAction.animateWithTextures(textureAtlas[Status.jump], timePerFrame: 1/16));
                status = Status.jump2;
            } else if status == Status.run || status == .roll{
                runAction(SKAction.animateWithTextures(textureAtlas[Status.jump], timePerFrame: 1/16));
                status = Status.jump;
            }
        }
    }
    
    func roll() {
        removeAllActions();
        status = .roll;
        runAction(SKAction.animateWithTextures(textureAtlas[Status.roll], timePerFrame: 1 / 16), completion: { () -> Void in
            self.run()
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
