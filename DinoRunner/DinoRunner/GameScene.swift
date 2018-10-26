//
//  GameScene.swift
//  DinoRunner
//
//  Created by John Kuhn on 7/29/18.
//  Copyright © 2018 John Kuhn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //nodes
    var groundNode: SKNode!
    var backgroundNode: SKNode!
    var cactusNode: SKNode!
    var dinosaurNode: SKNode!
    
    //sprites
    var dinoSprite: SKSpriteNode!
    
    //generic vars
    var groundHeight: CGFloat?
    var dinoYPosition: CGFloat?
    
    //consts
    let dinoHopForce = 700 as Int
    let groundSpeed = 500 as CGFloat
    let cloudSpeed = 50 as CGFloat
    let moonSpeed = 10 as CGFloat
    
    //collision categories
    let groundCategory = 1 << 1 as UInt32
    let dinoCategory = 1 << 2 as UInt32
    let cactusCategory = 1 << 3 as UInt32
    let birdCategory = 1 << 4 as UInt32
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        //ground
        groundNode = SKNode()
        createAndMoveGround()
        addCollisionToGround()
        self.addChild(groundNode)
        
        //background elements
        backgroundNode = SKNode()
        createMoon()
        createClouds()
        self.addChild(backgroundNode)
        
        //dinosaur
        dinosaurNode = SKNode()
        createDinosaur()
        self.addChild(dinosaurNode)
        
        //cacti
        cactusNode = SKNode()
        spawnCactus()
        self.addChild(cactusNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if let groundPosition = dinoYPosition {
                if dinoSprite.position.y <= groundPosition {
                    dinoSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: dinoHopForce))
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func createAndMoveGround() {
        let screenWidth = self.frame.size.width
        
        //ground texture
        let groundTexture = SKTexture(imageNamed: "dino.assets/landscape/ground")
        groundTexture.filteringMode = .nearest
        
        let homeButtonPadding = 50.0 as CGFloat
        groundHeight = groundTexture.size().height + homeButtonPadding
        
        //ground actions
        let moveGroundLeft = SKAction.moveBy(x: -groundTexture.size().width,
                                             y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let resetGround = SKAction.moveBy(x: groundTexture.size().width, y: 0.0, duration: 0.0)
        let groundLoop = SKAction.sequence([moveGroundLeft, resetGround])
        
        //ground nodes
        let numberOfGroundNodes = 1 + Int(ceil(screenWidth / groundTexture.size().width))
        
        for i in 0 ..< numberOfGroundNodes {
            let node = SKSpriteNode(texture: groundTexture)
            node.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            node.position = CGPoint(x: CGFloat(i) * groundTexture.size().width, y: groundHeight!)
            groundNode.addChild(node)
            node.run(SKAction.repeatForever(groundLoop))
        }
    }
    
    func addCollisionToGround() {
        let groundContactNode = SKNode()
        groundContactNode.position = CGPoint(x: 0, y: groundHeight! - 40)
        groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 3,
                                                                          height: groundHeight!))
        groundContactNode.physicsBody?.friction = 0.0
        groundContactNode.physicsBody?.isDynamic = false
        groundContactNode.physicsBody?.categoryBitMask = groundCategory
        
        groundNode.addChild(groundContactNode)
    }
    
    func createMoon() {
        //texture
        let moonTexture = SKTexture(imageNamed: "dino.assets/landscape/moon")
        moonTexture.filteringMode = .nearest
        
        //moon sprite
        let moonSprite = SKSpriteNode(texture: moonTexture)
        
        //add to scene
        backgroundNode.addChild(moonSprite)
        
        //animate the moon
        animateMoon(moonSprite, moonTexture)
    }
    
    func animateMoon(_ sprite: SKSpriteNode, _ texture: SKTexture) {
        let screenWidth = self.frame.size.width
        let screenHeight = self.frame.size.height
        
        let distanceOffscreen = 50.0 as CGFloat // want to start the moon offscreen
        let distanceBelowTop = 150 as CGFloat
        
        //moon actions
        let moveMoon = SKAction.moveBy(x: -screenWidth - texture.size().width - distanceOffscreen,
                                       y: 0.0, duration: TimeInterval(screenWidth / moonSpeed))
        let resetMoon = SKAction.moveBy(x: screenWidth + distanceOffscreen, y: 0.0, duration: 0)
        let moonLoop = SKAction.sequence([moveMoon, resetMoon])
        
        sprite.position = CGPoint(x: screenWidth + distanceOffscreen, y: screenHeight - distanceBelowTop)
        sprite.run(SKAction.repeatForever(moonLoop))
    }
    
    func createClouds() {
        //texture
        let cloudTexture = SKTexture(imageNamed: "dino.assets/landscape/cloud")
        cloudTexture.filteringMode = .nearest
        
        //clouds
        let numClouds = 3
        for i in 0 ..< numClouds {
            //create sprite
            let cloudSprite = SKSpriteNode(texture: cloudTexture)
            
            //add to scene
            backgroundNode.addChild(cloudSprite)
            
            //animate the cloud
            animateCloud(cloudSprite, cloudIndex: i, textureWidth: cloudTexture.size().width)
        }
    }
    
    func animateCloud(_ sprite: SKSpriteNode, cloudIndex i: Int, textureWidth: CGFloat) {
        let screenWidth = self.frame.size.width
        let screenHeight = self.frame.size.height
        
        let cloudOffscreenDistance = (screenWidth / 3.0) * CGFloat(i) + 100 as CGFloat
        let cloudYPadding = 50 as CGFloat
        let cloudYPosition = screenHeight - (CGFloat(i) * cloudYPadding) - 200
        
        let distanceToMove = screenWidth + cloudOffscreenDistance + textureWidth
        
        //actions
        let moveCloud = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(distanceToMove / cloudSpeed))
        let resetCloud = SKAction.moveBy(x: distanceToMove, y: 0.0, duration: 0.0)
        let cloudLoop = SKAction.sequence([moveCloud, resetCloud])
        
        sprite.position = CGPoint(x: screenWidth + cloudOffscreenDistance, y: cloudYPosition)
        sprite.run(SKAction.repeatForever(cloudLoop))
    }
    
    func createDinosaur() {
        let screenWidth = self.frame.size.width
        let dinoScale = 3.0 as CGFloat
        
        //textures
        let dinoTexture1 = SKTexture(imageNamed: "dino.assets/dinosaurs/dinoRight")
        let dinoTexture2 = SKTexture(imageNamed: "dino.assets/dinosaurs/dinoLeft")
        let deadDinoTexture = SKTexture(imageNamed: "dino.assets/dinosaurs/dinoDead")
        dinoTexture1.filteringMode = .nearest
        dinoTexture2.filteringMode = .nearest
        deadDinoTexture.filteringMode = .nearest
        
        let runningAnimation = SKAction.animate(with: [dinoTexture1, dinoTexture2], timePerFrame: 0.12)
        
        dinoSprite = SKSpriteNode()
        dinoSprite.size = dinoTexture1.size()
        dinoSprite.setScale(dinoScale)
        dinosaurNode.addChild(dinoSprite)
        
        let physicsBox = CGSize(width: dinoTexture1.size().width * dinoScale,
                                height: dinoTexture1.size().height * dinoScale)
        
        dinoSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
        dinoSprite.physicsBody?.isDynamic = true
        dinoSprite.physicsBody?.mass = 1.0
        dinoSprite.physicsBody?.categoryBitMask = dinoCategory
        dinoSprite.physicsBody?.contactTestBitMask = groundCategory | birdCategory
        dinoSprite.physicsBody?.collisionBitMask = groundCategory | birdCategory
        
        if let dinoY = groundHeight {
            dinoYPosition = dinoY + dinoTexture1.size().height * dinoScale
            dinoSprite.position = CGPoint(x: screenWidth * 0.15, y: dinoYPosition!)
            dinoSprite.run(SKAction.repeatForever(runningAnimation))
        } else {
            print("Ground size wasn't previously calculated")
            exit(0)
        }
    }
    
    func spawnCactus() {
        let cactusTextures = ["cactus1", "cactus2", "cactus3", "doubleCactus", "tripleCactus" ,"quadCactus"]
        let cactusIndex = Int.random(in: 0 ..< cactusTextures.count)
        
        //texture
        let cactusTexture = SKTexture(imageNamed: "dino.assets/cacti/" + cactusTextures[cactusIndex])
        cactusTexture.filteringMode = .nearest
        
        //sprite
        let cactusSprite = SKSpriteNode(texture: cactusTexture)
        
        //physics
        cactusSprite.physicsBody = SKPhysicsBody(rectangleOf: cactusTexture.size())
        cactusSprite.physicsBody?.isDynamic = true
        cactusSprite.physicsBody?.mass = 1.0
        cactusSprite.physicsBody?.categoryBitMask = cactusCategory
        cactusSprite.physicsBody?.contactTestBitMask = dinoCategory
        cactusSprite.physicsBody?.collisionBitMask = dinoCategory | groundCategory
        
        //add to scene
        cactusNode.addChild(cactusSprite)
        //animate
        animateCactus(sprite: cactusSprite, texture: cactusTexture)
    }
    
    func animateCactus(sprite: SKSpriteNode, texture: SKTexture) {
        let screenWidth = self.frame.size.width
        let distanceOffscreen = 50.0 as CGFloat
        let distanceToMove = screenWidth + distanceOffscreen + texture.size().width
        
        //actions
        let moveCactus = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        
        if let gHeight = groundHeight {
            sprite.position = CGPoint(x: distanceToMove, y: gHeight + texture.size().height)
            sprite.run(moveCactus)
        } else {
            print("Ground size wasn't previously calculated")
            exit(0)
        }
    }
    
}
