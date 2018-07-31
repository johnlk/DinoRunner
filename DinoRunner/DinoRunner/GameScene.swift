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
    
    var ground: SKNode!
    
    override func didMove(to view: SKView) {
        
        view.backgroundColor = .grey
        
        let screenWidth = self.frame.size.width
        
        let groundTexture = SKTexture(imageNamed: "dino.assets/landscape/ground")
        groundTexture.filteringMode = .nearest
        
        let moveGroundLeft = SKAction.moveBy(x: -screenWidth, y: 0, duration: TimeInterval(screenWidth / 100))
        let resetGround = SKAction.moveBy(x: screenWidth, y: 0, duration: 0.0)
        let runGround = SKAction.repeatForever(SKAction.sequence([moveGroundLeft, resetGround]))
        
        let groundSprite = SKSpriteNode(texture: groundTexture)
        groundSprite.anchorPoint = CGPoint(x: 0, y: 0)
        groundSprite.size = CGSize(width: screenWidth, height: groundTexture.size().height / 2)
        groundSprite.setScale(2.0)
        groundSprite.position = CGPoint(x: 0, y: groundTexture.size().height)
        
        groundSprite.run(runGround)
        
        self.addChild(groundSprite)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
