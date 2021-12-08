//
//  GameScene.swift
//  Challenge6
//
//  Created by MadiApps on 08/12/2021.
//

import SpriteKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var gameOverTimer: Timer!
    var targetMaker: Timer!
    
    var bulletNodes = [SKSpriteNode]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var bulletsLeft = 6 {
        didSet {
            updateBulletsNum()
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        for bullet in 1...bulletsLeft {
            let bulletNode = SKSpriteNode(imageNamed: "bullet")
            let bulletX : Int = 90 + bullet * 50
            bulletNode.position = CGPoint(x: bulletX, y: 70)
            bulletNodes.append(bulletNode)
        }
        
        configureScene()
        bulletsLeft = 6
        score = 0
        
        let curtain = SKSpriteNode(imageNamed: "curtain")
        curtain.position = CGPoint(x: 512, y: 384)
        curtain.zPosition = 2
        addChild(curtain)
        
        gameOverTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(gameOver), userInfo: nil, repeats: false)
    }
    
    @objc private func gameOver() {
        gameOverTimer.invalidate()
        
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over !"
        gameOverLabel.fontColor = UIColor.black
        gameOverLabel.fontSize = 42
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        addChild(gameOverLabel)
    }
    
    private func configureScene() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 800, y: 35)
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        
        targetMaker = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createShootableTarget), userInfo: nil, repeats: true)
    }
    
    @objc private func createShootableTarget() {
        
        let decision = Int.random(in: 1...10)
        if decision <= 3 && decision >= 1 {
            makeBigTarget(at: CGPoint(x: -250, y: 500), isBad: true)
        } else {
            makeSmallTarget(at: CGPoint(x: 1200, y: 250), isBad: true)
        }
    }
    
    private func updateBulletsNum() {
        for bulletNode in bulletNodes {
            bulletNode.removeFromParent()
        }
        
        for bullet in 0..<bulletsLeft {
            addChild(bulletNodes[bullet])
        }
    }
    
    private func makeBigTarget(at position: CGPoint, isBad: Bool) {
        makeTarget(at: position, isBad: isBad, type: "big")
    }
    
    private func makeSmallTarget(at position: CGPoint, isBad: Bool) {
        makeTarget(at: position, isBad: isBad, type: "small")
    }
    
    private func makeTarget(at position: CGPoint, isBad: Bool, type: String) {
        let target:SKSpriteNode
        var targetName = "target"
        if isBad {
            target = SKSpriteNode(imageNamed: "targetBad")
            targetName += "Bad"
        } else {
            target = SKSpriteNode(imageNamed: "targetGood")
            targetName += "Good"
        }
        switch type {
        case "big":
            targetName += "Big"
            target.physicsBody = SKPhysicsBody(circleOfRadius: target.size.width/2)
            target.physicsBody?.velocity = CGVector(dx: 250, dy: 0)
            target.physicsBody?.linearDamping = 0
        case "small":
            targetName += "Small"
            target.xScale = 0.5
            target.yScale = 0.5
            target.physicsBody = SKPhysicsBody(circleOfRadius: target.size.width/2)
            target.physicsBody?.velocity = CGVector(dx: -400, dy: 0)
            target.physicsBody?.linearDamping = 0
        default:
            targetName += "Default"
        }
        target.name = targetName
        target.position = position
        addChild(target)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        bulletsLeft -= 1
        if bulletsLeft > 0 {
            for node in tappedNodes {
                switch node.name {
                case "targetGoodBig":
                    explosion(at: location)
                    node.removeFromParent()
                    score -= 5
                case "targetBadBig":
                    explosion(at: location)
                    node.removeFromParent()
                    score += 3
                case "targetGoodSmall":
                    explosion(at: location)
                    node.removeFromParent()
                    score -= 3
                case "targetBadSmall":
                    explosion(at: location)
                    node.removeFromParent()
                    score += 5
                default:
                    continue
                }
            }
        } else {
            gameOver()
        }
    }
    
    private func explosion(at position: CGPoint) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = position
        addChild(explosion)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
            if node.position.x > 1300 {
                node.removeFromParent()
            }
        }
    }
}
