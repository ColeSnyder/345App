//
//  GameScene.swift
//  Trump Jump
//
//  Created by Snyder, Cole M on 11/3/17.
//  Copyright © 2017 Snyder, Cole M. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var trumpRun = SKSpriteNode()
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    
    var ground = SKSpriteNode()
    var trump = SKSpriteNode()
    var trumpNormalLeft = SKSpriteNode()
    var run: Bool = false
    var gameStart: Bool = false
    
    let label1 = SKLabelNode(fontNamed: "Chalkduster")
    let subLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView) {
        gameStart = false
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor.blue
        
        textureAtlas = SKTextureAtlas(named: "Images")
        for i in 1...textureAtlas.textureNames.count{
            let Name = "trump\(i).png"
            textureArray.append(SKTexture(imageNamed: Name))
        }
        
        trumpRun = SKSpriteNode(imageNamed: "trumpNormalStill.png")
        trumpRun.size = CGSize(width: 400, height: 300)
        trumpRun.position = CGPoint(x: -200, y: (self.scene?.size.height)! * -0.30)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor.blue
        
        label1.text = "Trump Jump"
        label1.fontSize = 75
        label1.fontColor = SKColor.white
        label1.position = CGPoint(x: 0, y: 550)
        
        subLabel.text = "(Tap anywhere to start)"
        subLabel.fontSize = 35
        subLabel.fontColor = SKColor.white
        subLabel.position = CGPoint(x: 0, y: 450)
        
        makeGround()
        self.addChild(label1)
        self.addChild(subLabel)
        self.addChild(trumpRun)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?){
            runningTrump()
            gameStart = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStart == true {
            moveGround()
            moveGround()
            moveGround()
            moveGround()
            subLabel.text = ""
        }
    }
    
    func makeGround(){
        for i in 0...3 {
            let ground = SKSpriteNode(imageNamed: "groundDiff")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height/2))
            self.addChild(ground)
        }
    }
    
    func moveGround(){
        self.enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in

            node.position.x -= 2

            if node.position.x < (-(self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func runningTrump() {
        trumpRun.run(SKAction.repeatForever(
            SKAction.animate(with: textureArray, timePerFrame: 0.1, resize: false, restore: true)),
                     withKey:"TrumpRunningNow")
    }
}
