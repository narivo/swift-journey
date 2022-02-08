//
//  GameScene.swift
//  Project26
//
//  Created by MadiApps on 31/01/2022.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    
    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false
    
    var level = 1
    
    override func didMove(to view: SKView) {
        resetBoard()
        load(level)
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func load(_ num: Int) {
        guard let url = Bundle.main.url(forResource: "level\(num)", withExtension: ".txt") else { fatalError("Couldn't find level\(num).txt") }
        guard let file = try? String(contentsOf: url) else { fatalError("level\(num).txt found but it cannot be loaded") }
        
        let lines = file.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    createWallBlock(position)
                } else if letter == "v"  {
                    createVortexBlock(position)
                } else if letter == "s"  {
                    createStarBlock(position)
                } else if letter == "f"  {
                    createFinishBlock(position)
                } else if letter == " " {
                    // this is an empty space – do nothing!
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
                
            }
        }
    }
    
    fileprivate func createWallBlock(_ position: CGPoint) {
        // load wall
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        
        addChild(node)
    }
    
    fileprivate func createVortexBlock(_ position: CGPoint) {
        // load vortex
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        
        addChild(node)
    }
    
    fileprivate func createStarBlock(_ position: CGPoint) {
        // load star
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        
        addChild(node)
    }
    
    fileprivate func createFinishBlock(_ position: CGPoint) {
        // load finish
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.position = position
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.isDynamic = false
        
        addChild(node)
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 4
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {

            score -= 1
            mitigate(with: node)
            
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            level += 1
            loadNext(level, with: node)
        }
    }
    
    func mitigate(with node: SKNode) {
        player.physicsBody?.isDynamic = false
        isGameOver = true
        
        let move = SKAction.move(to: node.position, duration: 0.25)
        let scale = SKAction.scale(to: 0.0001, duration: 0.25)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, scale, remove])
        
        player.run(sequence) { [weak self] in
            self?.createPlayer()
            self?.isGameOver = false
        }
    }
    
    func loadNext(_ level: Int, with node: SKNode) {
        player.physicsBody?.isDynamic = false
        isGameOver = true
        
        let move = SKAction.move(to: node.position, duration: 0.25)
        let scale = SKAction.scale(to: 0.0001, duration: 0.25)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, scale, remove])
        
        player.run(sequence) { [weak self] in
            self?.resetBoard()
            self?.load(level)
            self?.createPlayer()
            self?.isGameOver = false
        }
    }
    
    func resetBoard() {
        for node in children {
            node.removeFromParent()
        }
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
    }
}
