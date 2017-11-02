//
//  GameScene.swift
//  ProjectGoGo
//
//  Created by Blong, Natasha M on 11/1/17.
//  Copyright © 2017 Blong, Natasha M. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        let normalTrump = SKSpriteNode(imageNamed: "trumpRage.png")
        
        normalTrump.size.width = 150
        normalTrump.size.height = 150
        normalTrump.position = CGPoint(x: 0, y: 0)
        
        self.addChild(normalTrump)

        
    }
}
