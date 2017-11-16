//
//  GameScene.swift
//  Trump Jump
//
//  Created by Snyder, Cole M on 11/3/17.
//  Copyright © 2017 Snyder, Cole M. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollisionMask
{
    static let trumpSmash:UInt32 = 0x1 << 0
    static let wallSmash:UInt32 = 0x1 << 1
    static let sprayTanSmash:UInt32 = 0x1 << 2
    static let groundSmash:UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var trumpRun = SKSpriteNode()
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    
    var ground = SKSpriteNode()
    var trump = SKSpriteNode()
    var trumpNormalLeft = SKSpriteNode()
    var run: Bool = false
    var gameStart: Bool = false
    var wall = SKNode()
    var moveAndRemove = SKAction()
    
    let label1 = SKLabelNode(fontNamed: "Chalkduster")
    let subLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    override func didMove(to view: SKView)
    {
        gameStart = false
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor.blue
        
        textureAtlas = SKTextureAtlas(named: "Images")
        for i in 1...textureAtlas.textureNames.count
        {
            let Name = "trump\(i).png"
            textureArray.append(SKTexture(imageNamed: Name))
        }
        
        trumpRun = SKSpriteNode(imageNamed: "trumpNormalStill.png")
        trumpRun.size = CGSize(width: 320, height: 220)
        trumpRun.position = CGPoint(x: -200, y: (self.scene?.size.height)! * -0.33)
        
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
        
        let distance = CGFloat(self.frame.width + wall.frame.width)
        let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
        let removePipes = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([movePipes, removePipes])
        
        makeGround()
        self.addChild(label1)
        self.addChild(subLabel)
        self.addChild(trumpRun)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?){
            trumpToggleJump()
            gameStart = true
            runningTrump()
            trump.physicsBody?.affectedByGravity = true
        
        self.wall = self.createWall()
        self.addChild(self.wall)
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
    
    func trumpToggleJump() {

        if trumpRun.position.y < (self.scene?.size.height)! * -0.32 {
            
            let jumpUpAction = SKAction.moveBy(x: 0, y:500, duration:0.2)
            let jumpDownAction = SKAction.moveBy(x: 0, y:-500, duration:0.3)
            let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])
            
            trumpRun.run(jumpSequence)
            
            }
    }
    func createWall() -> SKNode {
        wall = SKNode()
        wall.name = "wall"
        
        let trumpWall = SKSpriteNode(imageNamed: "wall")
        
        trumpWall.position = CGPoint(x: self.frame.width + 25, y: 0 - 600)
        trumpWall.setScale(0.75)
        trumpWall.physicsBody = SKPhysicsBody(rectangleOf: trumpWall.size)
        trumpWall.physicsBody?.categoryBitMask = CollisionMask.wallSmash
        trumpWall.physicsBody?.collisionBitMask = CollisionMask.trumpSmash
        trumpWall.physicsBody?.contactTestBitMask = CollisionMask.trumpSmash
        trumpWall.physicsBody?.isDynamic = false
        trumpWall.physicsBody?.affectedByGravity = false
        
        wall.addChild(trumpWall)
        wall.zPosition = 1
        let randomPosition = random(min: 0, max: 25)
        wall.position.y = wall.position.y +  randomPosition
        //wall.addChild(sprayTanNode)
        
        wall.run(moveAndRemove)
        return wall
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func createTrump() -> SKSpriteNode {
        let trump = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("trump1"))
        trump.size = CGSize(width: 50, height: 50)
        trump.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        trump.physicsBody = SKPhysicsBody(circleOfRadius: trump.size.width / 2)
        trump.physicsBody?.linearDamping = 1.1
        trump.physicsBody?.restitution = 0
        trump.physicsBody?.categoryBitMask = CollisionMask.trumpSmash
        trump.physicsBody?.collisionBitMask = CollisionMask.wallSmash | CollisionMask.groundSmash
        trump.physicsBody?.contactTestBitMask = CollisionMask.wallSmash | CollisionMask.sprayTanSmash | CollisionMask.groundSmash
        trump.physicsBody?.affectedByGravity = false
        trump.physicsBody?.isDynamic = true
        return trump
}
}
