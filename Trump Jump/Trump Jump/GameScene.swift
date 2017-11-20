//
//  GameScene.swift
//  Trump Jump
//
//  Created by Snyder, Cole M on 11/3/17.
//  Copyright © 2017 Snyder, Cole M. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollisionBitMask
{
    static let trumpSmash:UInt32 = 1
    static let wallSmash:UInt32 = 2
    static let sprayTanSmash:UInt32 = 4
//    static let groundSmash:UInt32 = 0x1 << 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var firstTime: Bool = true
    
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
        physicsWorld.contactDelegate = self
        
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
        trumpRun.physicsBody = SKPhysicsBody(rectangleOf: trumpRun.size)
        trumpRun.physicsBody?.affectedByGravity = false
        
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
        
//      let randomDistance = random(min: 0.004, max: 0.010)
        let distance = CGFloat(self.frame.width + wall.frame.width)
        let moveWalls = SKAction.moveBy(x: -distance - 400, y: 0, duration: TimeInterval(0.008 * distance/3))
//      replace the argunment for time interval in following line with a variable that changes every ~20 seconds to make it faster
        //let moveWalls = SKAction.moveBy(x: -distance - 200, y: 0, duration: TimeInterval(1.4))
//      replaced following line with '2' in line above this
//      randomDistance * distance / 4
        let removeWalls = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveWalls, removeWalls])
        
        makeGround()
        self.addChild(label1)
        self.addChild(subLabel)
        self.addChild(trumpRun)
        run(SKAction.playSoundFileNamed("reflections.mp3", waitForCompletion: false))
    }
    
//    func didBegin(_ contact: SKPhysicsContact){
//
//        let firstBody = contact.bodyA
//        let secondBody = contact.bodyB
//
//        if firstBody.categoryBitMask == CollisionBitMask.trumpSmash && secondBody.categoryBitMask == CollisionBitMask.wallSmash || firstBody.categoryBitMask == CollisionBitMask.wallSmash && secondBody.categoryBitMask == CollisionBitMask.trumpSmash
//        {
//            enumerateChildNodes(withName: "wall", using: ({
//                (firstBody, error) in
//                NSLog("contact")
//                firstBody.speed = 0
//                self.removeAllActions()
//            }))
//        }
//    }
//
//    func didEndContact(contact: SKPhysicsContact){
//
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?){
            gameStart = true
            trumpToggleJump()
            runningTrump()
            trump.physicsBody?.affectedByGravity = true
    }
    
    override func update(_ currentTime: TimeInterval) {
            if gameStart == true {
                moveGround()
                moveGround()
                moveGround()
                moveGround()
                moveGround()
                moveGround()
                moveGround()
                moveGround()
                moveGround()
                subLabel.text = ""
            }
            if gameStart == true && firstTime{
                self.spawnWall()
                firstTime = false
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
            if trumpRun.position.y < (self.scene?.size.height)! * -0.30 {
                let jumpUpAction = SKAction.moveBy(x: 0, y:500, duration:0.2)
                let jumpDownAction = SKAction.moveBy(x: 0, y:-500, duration:0.4)
                let jump = SKAction.sequence([jumpUpAction, jumpDownAction])
                trumpRun.run(jump)
        }
    }
    
    func createWall() -> SKNode {
        wall = SKNode()
        wall.name = "wall"
        
        let trumpWall = SKSpriteNode(imageNamed: "wall")
        
        trumpWall.position = CGPoint(x: self.frame.width + 25, y: 0 - 475)
        trumpWall.setScale(0.35)
        trumpWall.physicsBody = SKPhysicsBody(rectangleOf: trumpWall.size)
        //trumpWall.physicsBody?.categoryBitMask = CollisionBitMask.wallSmash
       // trumpWall.physicsBody?.collisionBitMask = CollisionBitMask.trumpSmash
        //trumpWall.physicsBody?.contactTestBitMask = CollisionBitMask.trumpSmash
        //trumpWall.physicsBody?.isDynamic = false
        trumpWall.physicsBody?.affectedByGravity = false
        
        wall.addChild(trumpWall)
        wall.zPosition = 1
        let randomPosition = random(min: 45, max: 50)
        wall.position.y = wall.position.y + randomPosition
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
        trump.physicsBody = SKPhysicsBody(circleOfRadius: trump.size.width)
       // trump.physicsBody?.linearDamping = 1.1
      //  trump.physicsBody?.restitution = 0
       // trump.physicsBody?.categoryBitMask = CollisionBitMask.trumpSmash
      //  trump.physicsBody?.collisionBitMask = CollisionBitMask.wallSmash
      //  trump.physicsBody?.collisionBitMask = CollisionBitMask.wallSmash
      //  trump.physicsBody?.contactTestBitMask = CollisionBitMask.wallSmash
        trump.physicsBody?.affectedByGravity = false
        //trump.physicsBody?.isDynamic = true
        return trump
    }
    
    func spawnWall(){
        if gameStart {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {(timer: Timer) -> Void in
                
                NSLog("logged")
                self.wall = self.createWall()
                self.addChild(self.wall)
            })
        } else{
            NSLog("...")
        }
    }
    
}
