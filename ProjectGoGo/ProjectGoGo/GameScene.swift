//
//  GameScene.swift
//  ProjectGoGo
//
//  Created by Blong, Natasha M on 11/1/17.
//  Copyright © 2017 Blong, Natasha M. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var gameStarted = Bool(false)
    var died = Bool(false)
    let normalTrump = SKSpriteNode(imageNamed: "trumpRage.png")
    
    override func didMove(to view: SKView) {
                
        normalTrump.size.width = 150
        normalTrump.size.height = 150
        normalTrump.position = CGPoint(x: 0, y: 0)
        
        self.addChild(normalTrump)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // if let label = self.label {
            //label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
       // for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

