//  GameScene.swift
//  Trump Jump
//
//  Created by Snyder, Cole M & Blong, Natasha M on 11/3/17.
//  Copyright © 2017 Snyder, Cole M & Blong, Natasha M. All rights reserved.

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let trumpCategory: UInt32 = 0x1 << 0
    let canCategory: UInt32   = 0x1 << 1
    let wallCategory: UInt32  = 0x1 << 2
    
    // Game Variables
    var gameStart: Bool = false
    var firstTime: Bool = true
    var dead: Bool = false
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    
    //Trump Related
    var trump = SKSpriteNode()
    var trumpRun = SKSpriteNode()
    var trumpNormalLeft = SKSpriteNode()
    var run: Bool = false
    
    // Scene Related
    var background = SKSpriteNode(imageNamed: "sky")
    var ground = SKSpriteNode()
    var wall = SKNode()
    var moveAndRemove = SKAction()
    var wallSpeed: CGFloat = 3.0
    var can = SKNode()
    var moveCanAndRemove = SKAction()
    var canSpeed: CGFloat = 3.0
    
    // Label Related
    var score = 0
    var meters: Int = 0
    var distanceTraveled = SKLabelNode(fontNamed: "Chalkduster")
    let label1 = SKLabelNode(fontNamed: "Chalkduster")
    let subLabel = SKLabelNode(fontNamed: "Chalkduster")
    let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
    var restartBtn = SKSpriteNode()
    
    // Audio
    let path = Bundle.main.path(forResource: "reflections.mp3", ofType:nil)!
    var gameMusic: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        firstTime = true
        dead = false
        physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = UIColor.white
        textureAtlas = SKTextureAtlas(named: "Images")
        for i in 1...textureAtlas.textureNames.count {
            let Name = "trump\(i).png"
            textureArray.append(SKTexture(imageNamed: Name))
        }
        
        // Trump Details
        trumpRun = SKSpriteNode(imageNamed: "trumpNormalStill.png")
        trumpRun.size = CGSize(width: 250, height: 220)
        trumpRun.position = CGPoint(x: -200, y: (self.scene?.size.height)! * -0.33)
        trumpRun.physicsBody = SKPhysicsBody(circleOfRadius: 60)
        trumpRun.physicsBody?.affectedByGravity = false
        trumpRun.physicsBody?.isDynamic = true
        
        // Trump Jump label Details
        label1.text = "Trump Jump"
        label1.fontSize = 75
        label1.fontColor = SKColor.white
        label1.position = CGPoint(x: 0, y: 550)
        
        // Start Label Details
        subLabel.text = "(Tap anywhere to start)"
        subLabel.fontSize = 35
        subLabel.fontColor = SKColor.white
        subLabel.position = CGPoint(x: 0, y: 450)
        
        // Restart Label Details
        restartLabel.text = ""
        restartLabel.fontSize = 35
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: 0, y: -100)
        
        //Distance Traveled Details
        distanceTraveled.text = "Distance: \(meters)"
        distanceTraveled.fontSize = 40
        distanceTraveled.fontColor = UIColor.white
        distanceTraveled.position = CGPoint(x: 0, y: (self.frame.size.height) / 3)
        
        // Wall Details
        let distance = CGFloat(self.frame.width + wall.frame.width)
        let moveWalls = SKAction.moveBy(x: -distance - 400, y: 0, duration: TimeInterval(0.008 * distance / wallSpeed))
        let removeWalls = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveWalls, removeWalls])

        
        // Spray Tan Can Details
        let canDistance = CGFloat(self.frame.width + can.frame.width)
        let moveCans = SKAction.moveBy(x: -canDistance, y: 0, duration: TimeInterval(0.008 * canDistance / canSpeed))
        let removeCans = SKAction.removeFromParent()
        moveCanAndRemove = SKAction.sequence([moveCans, removeCans])
        
        background.position = CGPoint(x: frame.size.width * 0.0, y: frame.size.height * 0.05)
        
        // Adding Children
        addChild(background)
        background.zPosition = 0
        makeGround()
        self.addChild(label1)
        label1.zPosition = 1
        self.addChild(subLabel)
        subLabel.zPosition = 1
        self.addChild(restartLabel)
        restartLabel.zPosition = 1
        self.addChild(trumpRun)
        trumpRun.zPosition = 1
        distanceTraveled.zPosition = 1
        trumpRun.physicsBody?.categoryBitMask = trumpCategory
        trumpRun.physicsBody?.collisionBitMask = wallCategory
    }
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?) {
            gameStart = true
            trumpToggleJump()
            runningTrump()
            trump.physicsBody?.affectedByGravity = true
            moveTrumpBack()
        for touch in touches {
            let location = touch.location(in: self)
            if restartBtn.contains(location) {
                goToGameScene()
                gameMusic?.stop()
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
            if (gameStart == true) && (self.dead == false) {
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
            if gameStart == true && firstTime {
                distanceTraveled.fontSize = 40
                distanceTraveled.fontColor = UIColor.white
                distanceTraveled.position = CGPoint(x: 0, y: (self.frame.size.height) / 3)

                let wait = SKAction.wait(forDuration:0.3)
                let action = SKAction.run {
                    self.meters = self.meters + 1
                    if (self.dead == false) {
                    self.distanceTraveled.text = "Distance: \(self.meters)"
                    }
                }
                run(SKAction.repeatForever(SKAction.sequence([wait, action])))
                self.spawnWall()
                self.spawnCan()
                gameMusic?.stop()
                firstTime = false
                self.speedOfBlocks()
                self.addChild(distanceTraveled)
                let url = URL(fileURLWithPath: path)
                do {
                    gameMusic = try AVAudioPlayer(contentsOf: url)
                    gameMusic?.play()
                    NSLog("playing music")
                } catch {
                    NSLog("couldn't play music")
                }
            }
            if trumpRun.position.x < -350 && dead == false {
                self.createRestartButton()
                restartLabel.text = "Restart Game"
                gameStart = false
            }
    }
    func makeGround() {
        for i in 0...3 {
            let ground = SKSpriteNode(imageNamed: "ground")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: 250)
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height/2))
            self.addChild(ground)
            ground.zPosition = 1
        }
    }
    func moveTrumpBack() {
        if trumpRun.position.x > -201 {
            trumpRun.position.x = -200
        }
    }
    func moveGround() {
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
                let jumpDownAction = SKAction.moveTo(y: (self.scene?.size.height)! * -0.33, duration: 0.4)
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
        trumpWall.physicsBody?.isDynamic = false
        trumpWall.physicsBody?.affectedByGravity = false
        wall.addChild(trumpWall)
        trumpWall.physicsBody?.categoryBitMask = wallCategory
        trumpWall.physicsBody?.contactTestBitMask = trumpCategory
        let randomPosition = random(min: 45, max: 50)
        wall.position.y = wall.position.y + randomPosition
        wall.run(moveAndRemove)
        return wall
    }
    func createCan() -> SKNode {
        can = SKNode()
        can.name = "can"
        let sprayTan = SKSpriteNode(imageNamed: "sprayTanCan")
        sprayTan.position = CGPoint(x: self.frame.width + 25, y: 0 - 200)
        sprayTan.setScale(2)
        sprayTan.physicsBody = SKPhysicsBody(rectangleOf: sprayTan.size)
        sprayTan.physicsBody?.isDynamic = false
        sprayTan.physicsBody?.affectedByGravity = false
        can.addChild(sprayTan)
        sprayTan.physicsBody?.categoryBitMask = trumpCategory
        sprayTan.physicsBody?.categoryBitMask = canCategory
        sprayTan.physicsBody?.contactTestBitMask = trumpCategory
        can.zPosition = 1
        let randomCanPosition = random(min: 0, max: 50)
        can.position.y = can.position.y + randomCanPosition
        can.run(moveCanAndRemove)
        return can
    }
    func random() -> CGFloat {
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
        trump.physicsBody?.affectedByGravity = false
        return trump
    }
    func spawnWall() {
        let randomDistance = random(min: 1.0, max: 1.6)
        if gameStart {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(randomDistance), repeats: true, block: {(timer: Timer) -> Void in
                NSLog("Wall Spawned")
                if (self.dead == false) {
                    self.wall = self.createWall()
                    self.addChild(self.wall)
                }
            })
        } else {
            NSLog("...")
        }
    }
    func spawnCan() {
        let randomCanDistance = random(min: 3.0, max: 5)
        if gameStart {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(randomCanDistance), repeats: true, block: {(timer: Timer) -> Void in
                NSLog("Can Spawned")
                if (self.dead == false) {
                    self.can = self.createCan()
                    self.addChild(self.can)
                   
                }
            })
        } else {
            NSLog("...")
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == canCategory | trumpCategory {
            NSLog("Spray Tan Can Hit!")
            let randomNum = random(min: 1, max: 6)
            var quote = SKAction.playSoundFileNamed("Quote\(randomNum).mp3", waitForCompletion: false)
            run(quote)
            contact.bodyA.node?.removeFromParent()
        }
        if collision == wallCategory | trumpCategory {
            NSLog("Wall Hit!")
        }
    }
    func createRestartButton()
    {
        NSLog("Off Screen")
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: 0, y: 0)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
        dead = true
    }
    func restartScene()
    {
        self.removeAllChildren()
        self.removeAllActions()
        dead = false
        firstTime = true
        score = 0
    }
    func updateScoreWithValue (value: Int) {
        meters += value
        if (self.dead == false) {
        distanceTraveled.text = ("Meters: \(meters)")
        }
    }
    func speedOfBlocks() {
        Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: {(timer: Timer) -> Void in
            // Increasing Wall Speed
            self.wallSpeed = self.wallSpeed + 0.8
            let distance = CGFloat(self.frame.width + self.wall.frame.width)
            let moveWalls = SKAction.moveBy(x: -distance - 400, y: 0, duration: TimeInterval(0.008 * distance / self.wallSpeed))
            let removeWalls = SKAction.removeFromParent()
            self.moveAndRemove = SKAction.sequence([moveWalls, removeWalls])
            // Increasing Spray Tan Can Speed
            self.canSpeed = self.canSpeed + 0.8
            let canDistance = CGFloat(self.frame.width + self.can.frame.width)
            let moveCans = SKAction.moveBy(x: -canDistance - 400, y: 0, duration: TimeInterval(0.008 * canDistance / self.canSpeed))
            let removeCans = SKAction.removeFromParent()
            self.moveCanAndRemove = SKAction.sequence([moveCans, removeCans])
            NSLog("Sped Up")
            self.moveGround()
        })
    }
    func goToGameScene() {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        gameScene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
}
