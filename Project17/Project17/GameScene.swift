//
//  GameScene.swift
//  Project17
//
//  Created by MadiApps on 01/12/2021.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var enemies = ["ball", "hammer", "tv"]
    var timer: Timer?
    var isGameOver = false

    var enemiesCreated = 0
    var lastLocation = CGPoint(x: 100, y: 384)
    var isMovingPlayer = false
    
    var timeInterval = 1.0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
    
        player = SKSpriteNode(imageNamed: "player")
        player.position = lastLocation
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc func createEnemy() {
        guard let enemy = enemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...718))
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        addChild(sprite)
        
        enemiesCreated += 1
        
        if enemiesCreated % 20 == 0 {
            timeInterval -= 0.1
            
            if timeInterval < 0.3 {
                timeInterval = 0.3
            }
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if isMovingPlayer == false {
            
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        location.y = location.y.clamp(100, 668)
        
        player.position = location
            
        //}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // best solution tested
        player.position = lastLocation
    }
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isMovingPlayer == false {
         
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            
            let move = SKAction.moveBy(x: location.x - lastLocation.x, y: location.y - lastLocation.y, duration: 0.5)
            
            isMovingPlayer = true
            player.run(move)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.isMovingPlayer = false
            }
        }
    }*/
    
    func didBegin(_ contact: SKPhysicsContact) {
        if !isGameOver {
            let explosion = SKEmitterNode(fileNamed: "explosion")!
            explosion.position = player.position
            addChild(explosion)
            
            player.removeFromParent()
            timer?.invalidate()
            
            isGameOver = true
        }
    }
    
}

extension CGFloat {
    func clamp(_ begin: CGFloat, _ end: CGFloat) -> CGFloat {
        if self < begin {
            return begin
        } else if self > end {
            return end
        }
        
        return self
    }
}
