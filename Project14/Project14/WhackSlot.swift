//
//  WhackSlot.swift
//  Project14
//
//  Created by MadiApps on 12/11/2021.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let slot = SKSpriteNode(imageNamed: "whackHole")
        addChild(slot)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        charNode.xScale = 1
        charNode.yScale = 1
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime*3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        if let smoke = SKEmitterNode(fileNamed: "SmokeParticles") {
            smoke.position = CGPoint(x: charNode.position.x, y: charNode.position.y+20)
            smoke.zPosition = 1
            addChild(smoke)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak smoke] in
                
                if let smoke = smoke {
                    smoke.removeFromParent()
                }
            }
        }
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run {
            [weak self] in
            self?.isVisible = false
        }
        
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
        
    }
}
