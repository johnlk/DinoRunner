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
    var groundLoop: SKAction!
    
    func createGround() {
        let screenWidth = self.frame.size.width
        
        //ground texture
        let groundTexture = SKTexture(imageNamed: "dino.assets/landscape/ground")
        groundTexture.filteringMode = .nearest
        
        //ground actions
        let moveGroundLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0.0, duration: TimeInterval(screenWidth / 100))
        let resetGround = SKAction.moveBy(x: groundTexture.size().width, y: 0.0, duration: 0.0)
        groundLoop = SKAction.sequence([moveGroundLeft, resetGround])
        
        //ground nodes
        let numberOfGroundNodes = 1 + Int(ceil(screenWidth / groundTexture.size().width))
        let homeButtonPadding = 50.0 as CGFloat
        for i in 0 ..< numberOfGroundNodes {
            let node = SKSpriteNode(texture: groundTexture)
            node.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            node.position = CGPoint(x: CGFloat(i) * groundTexture.size().width, y: groundTexture.size().height + homeButtonPadding)
            groundNode.addChild(node)
        }
    }
    
    func animateGround() {
        let repeatedAnimation = SKAction.repeatForever(groundLoop)
        groundNode.run(repeatedAnimation)
    }
    
    override func didMove(to view: SKView) {
        
        view.backgroundColor = .gray
        
        //ground
        groundNode = SKNode()
        self.addChild(groundNode)
        createGround()
        animateGround()
        
        
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
