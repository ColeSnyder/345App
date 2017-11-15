//
//  GameElements.swift
//  Trump Jump
//
//  Created by Blong, Natasha M on 11/7/17.
//  Copyright © 2017 Snyder, Cole M. All rights reserved.
//

import SpriteKit

struct CollisionMask
{
    static let trumpSmash:UInt32 = 0x1 << 0
    static let wallSmash:UInt32 = 0x1 << 1
    static let sprayTanSmash:UInt32 = 0x1 << 2
    static let groundSmash:UInt32 = 0x1 << 3
}

extension GameScene
{
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
