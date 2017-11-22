//  GameScene.swift
//  Trump Jump
//
//  Created by Snyder, Cole M on 11/3/17.
//  Copyright © 2017 Snyder, Cole M. All rights reserved.

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var firstTime: Bool = true
    var dead: Bool = false
    var score = 0
    var trumpRun = SKSpriteNode()
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    var restartBtn = SKSpriteNode()
    var ground = SKSpriteNode()
    var highscore = SKLabelNode()
    var trump = SKSpriteNode()
    var trumpNormalLeft = SKSpriteNode()
    var run: Bool = false
    var gameStart: Bool = false
    var wall = SKNode()
    var moveAndRemove = SKAction()
    var wallSpeed: CGFloat = 3.0
    let highscoreLbl = SKLabelNode()
    let label1 = SKLabelNode(fontNamed: "Chalkduster")
    let subLabel = SKLabelNode(fontNamed: "Chalkduster")
    let restartLabel = SKLabelNode(fontNamed: "Chalkduster")
    //var musicOff: Bool = true
    
    let path = Bundle.main.path(forResource: "reflections.mp3", ofType:nil)!
    var bombSoundEffect: AVAudioPlayer?
    
    override func didMove(to view: SKView)
    {
        dead = false
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
        trumpRun.size = CGSize(width: 220, height: 220)
        trumpRun.position = CGPoint(x: -200, y: (self.scene?.size.height)! * -0.33)
        trumpRun.physicsBody = SKPhysicsBody(circleOfRadius: 60)
        trumpRun.physicsBody?.affectedByGravity = false
        trumpRun.physicsBody?.isDynamic = true
        
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
        
        restartLabel.text = ""
        restartLabel.fontSize = 35
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: 0, y: -100)
        
        let distance = CGFloat(self.frame.width + wall.frame.width)
        let moveWalls = SKAction.moveBy(x: -distance - 400, y: 0, duration: TimeInterval(0.008 * distance / wallSpeed))
        let removeWalls = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveWalls, removeWalls])
        
        // self.createHighscoreLabel()
        
        makeGround()
        self.addChild(label1)
        self.addChild(subLabel)
        self.addChild(restartLabel)
        self.addChild(trumpRun)
        self.speedOfWalls()
       // self.playMusic()
        //run(SKAction.playSoundFileNamed("reflections.mp3", waitForCompletion: false))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?){
            gameStart = true
            trumpToggleJump()
            runningTrump()
            trump.physicsBody?.affectedByGravity = true
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if restartBtn.contains(location) {
                //bombSoundEffect?.stop()
                goToGameScene()
            }
        }
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
                //bombSoundEffect?.stop()
                firstTime = false
            }
            if trumpRun.position.x < -425 && dead == false {
                self.createRestartButton()
                restartLabel.text = "Restart Game"
                //bombSoundEffect?.stop()
                musicOff = true
            }
            if dead == false && musicOff == true{
                run(SKAction.playSoundFileNamed("reflections.mp3", waitForCompletion: false))
                musicOff = false
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
        trumpWall.physicsBody?.isDynamic = false
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
        trump.physicsBody?.affectedByGravity = false
        return trump
    }
    
    func spawnWall(){
        let randomDistance = random(min: 1.0, max: 1.6)
        
        if gameStart {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(randomDistance), repeats: true, block: {(timer: Timer) -> Void in
                
                NSLog("Wall Spawned")
                self.wall = self.createWall()
                self.addChild(self.wall)
            })
        } else{
            NSLog("...")
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
        //we need to re-initialize all of the things needed to create a new game
    }
    
    func createHighscoreLabel() -> SKLabelNode
    {
        //let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        highscoreLbl.text = "Highest Score: 0"
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
       // self.highScore()
        return highscoreLbl
    }
    
//    func highScore() -> SKLabelNode {
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer: Timer) -> Void in
//            while self.dead == false {
//                self.highscoreLbl.text = "\(self.score + 3)"
//            }
//        })
//        return self.highscoreLbl
//
//    }
    
    func speedOfWalls(){
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: {(timer: Timer) -> Void in
                self.wallSpeed = self.wallSpeed + 0.8
                let distance = CGFloat(self.frame.width + self.wall.frame.width)
                let moveWalls = SKAction.moveBy(x: -distance - 400, y: 0, duration: TimeInterval(0.008 * distance / self.wallSpeed))
                let removeWalls = SKAction.removeFromParent()
                self.moveAndRemove = SKAction.sequence([moveWalls, removeWalls])
                NSLog("Sped Up")
            })
    }
    
    func goToGameScene() {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        gameScene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
//    func playMusic() {
//        let url = URL(fileURLWithPath: path)
//        do {
//            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
//            bombSoundEffect?.play()
//        } catch {
//            NSLog("cant Play Music")
//        }
//    }
    
}
