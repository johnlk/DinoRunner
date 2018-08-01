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
    
    var groundNode: SKNode!
    
    var backgroundNode: SKNode!
    
    var dinosaurNode: SKNode!
    var dinoSprite: SKSpriteNode!
    
    var groundHeight: CGFloat?
    
    let groundCategory = 0b0001 as UInt32
    let dinoCategory = 0b0010 as UInt32
    
    func createGround() {
        let screenWidth = self.frame.size.width
        
        //ground texture
        let groundTexture = SKTexture(imageNamed: "dino.assets/landscape/ground")
        groundTexture.filteringMode = .nearest
        
        let homeButtonPadding = 50.0 as CGFloat
        groundHeight = groundTexture.size().height + homeButtonPadding
        
        //ground actions
        let groundSpeed = 1.0 / 150 as CGFloat
        let moveGroundLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0.0, duration: TimeInterval(screenWidth * groundSpeed))
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
        
        let groundContactNode = SKNode()
        groundContactNode.position = CGPoint(x: 0, y: groundHeight! - 40)
        groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: groundHeight!))
        groundContactNode.physicsBody?.friction = 0.0
        groundContactNode.physicsBody?.isDynamic = false
        groundContactNode.physicsBody?.categoryBitMask = groundCategory
        
        groundNode.addChild(groundContactNode)
    }
    
    func createAndRunBackground() {
        let screenWidth = self.frame.size.width
        let screenHeight = self.frame.size.height
        
        //textures
        let cloudTexture = SKTexture(imageNamed: "dino.assets/landscape/cloud")
        let moonTexture = SKTexture(imageNamed: "dino.assets/landscape/moon")
        cloudTexture.filteringMode = .nearest
        moonTexture.filteringMode = .nearest
        
        //actions
        let cloudSpeed = 1.0 / 50 as CGFloat
        let moonSpeed = 1.0 / 5 as CGFloat
        
        let cloudPadding = screenWidth / 3
        let moveMoon = SKAction.moveBy(x: -screenWidth - 100, y: 0.0, duration: TimeInterval(screenWidth * moonSpeed))
        let resetMoon = SKAction.moveBy(x: screenWidth + 100, y: 0.0, duration: 0)
        let moonLoop = SKAction.sequence([moveMoon, resetMoon])
        
        //clouds
        let numClouds = 3
        for i in 0 ..< numClouds {
            let cloudSprite = SKSpriteNode(texture: cloudTexture)
            cloudSprite.position = CGPoint(x: screenWidth + 50 + cloudPadding * CGFloat(i),
                                           y: screenHeight - 200 - CGFloat(i * 50))
            
            let moveCloud = SKAction.moveBy(x: -screenWidth - 100 - cloudPadding * CGFloat(i),
                                            y: 0.0, duration: TimeInterval((screenWidth + cloudPadding * CGFloat(i)) * cloudSpeed))
            let resetCloud = SKAction.moveBy(x: screenWidth + 100 + cloudPadding * CGFloat(i),
                                             y: 0.0, duration: 0.0)
            let cloudLoop = SKAction.sequence([moveCloud, resetCloud])
            
            backgroundNode.addChild(cloudSprite)
            cloudSprite.run(SKAction.repeatForever(cloudLoop))
        }
        
        //moon sprite
        let moonSprite = SKSpriteNode(texture: moonTexture)
        moonSprite.position = CGPoint(x: screenWidth - 50, y: screenHeight - 150)
        
        backgroundNode.addChild(moonSprite)
        
        moonSprite.run(SKAction.repeatForever(moonLoop))
    }
    
    func createDinosaur() {
        let screenWidth = self.frame.size.width
        
        //textures
        let dinoTexture1 = SKTexture(imageNamed: "dino.assets/dinosaurs/dino1")
        let dinoTexture2 = SKTexture(imageNamed: "dino.assets/dinosaurs/dino2")
        let deadDinoTexture = SKTexture(imageNamed: "dino.assets/dinosaurs/dinoDead")
        dinoTexture1.filteringMode = .nearest
        dinoTexture2.filteringMode = .nearest
        deadDinoTexture.filteringMode = .nearest
        
        let runningAnimation = SKAction.animate(with: [dinoTexture1, dinoTexture2], timePerFrame: 0.2)
        
        dinoSprite = SKSpriteNode()
        dinoSprite.size = dinoTexture1.size()
        dinosaurNode.addChild(dinoSprite)
        
        dinoSprite.physicsBody = SKPhysicsBody(rectangleOf: dinoTexture1.size())
        dinoSprite.physicsBody?.isDynamic = true
        dinoSprite.physicsBody?.mass = 1.0
        dinoSprite.physicsBody?.categoryBitMask = dinoCategory
        dinoSprite.physicsBody?.contactTestBitMask = groundCategory
        dinoSprite.physicsBody?.collisionBitMask = groundCategory
        
        if let dinoY = groundHeight {
            dinoSprite.position = CGPoint(x: screenWidth * 0.15, y: dinoY + dinoTexture1.size().height + 500)
            dinoSprite.run(SKAction.repeatForever(runningAnimation))
        } else {
            print("Ground size wasn't previously calculated")
            exit(0)
        }
        
    }
    
    func sendCacti() {
        
    }
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .white
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        //ground
        groundNode = SKNode()
        self.addChild(groundNode)
        createGround()
        
        //background elements
        backgroundNode = SKNode()
        self.addChild(backgroundNode)
        createAndRunBackground()
        
        //dinosaur
        dinosaurNode = SKNode()
        self.addChild(dinosaurNode)
        createDinosaur()
        
        //cacti
        sendCacti()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            dinoSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
