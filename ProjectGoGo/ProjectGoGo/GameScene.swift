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
    
        override func didMove(to view: SKView) {
            
            var label1 = SKLabelNode(fontNamed:"Chalkduster")
            label1.text = "Trump Jump"
            label1.fontSize = 35
            label1.fontColor = SKColor.blue
            
            label1.position = CGPoint(x: self.frame.size.width/2,y: self.frame.size.height * 0.9)
            
            self.addChild(label1)
            
            
            
//            var ground = SKSpriteNode()
//            self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            makeGround()
//            self.addChild(ground)
            
    }
    
    override func update(_ currentTime: TimeInterval) {
        //moveGround()
    }

//    func makeGround(){
//
//        for i in 0...3{
//            let ground = SKSpriteNode(imageNamed: "ground")
//            ground.name = "Ground"
//            ground.size = CGSize(width: (self.scene?.size.width)!, height: 250)
//            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
//
//            self.addChild(ground)
//        }
//    }
//
//    func moveGround(){
//        self.enumerateChildNodes(withName: "Ground", using: ({
//            (node, error) in
//
//            node.position.x -= 2
//
//            if node.position.x < -(self.scene?.size.width)!{
//                node.position.x += (self.scene?.size.width)! * 3
//            }
//        }))
//    }

}

