//
//  GameScene.swift
//  UnderWater
//
//  Created by Павел on 11/17/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
  static let none: UInt32 = 0
  static let all: UInt32 = UInt32.max
  static let shark: UInt32 = 0b1
  static let obstacle: UInt32 = 0b10
  static let barrel: UInt32 = 0b11
  static let missile: UInt32 = 0b100
  static let submarine: UInt32 = 0b101
  static let health: UInt32 = 0b110
  static let score:UInt32 = 0b111
}


class GameScene: SKScene {

    let submarine = SKSpriteNode(imageNamed: "submarine")
    let rect = CGRect(x: 0, y: 0, width: 700, height: 10)
    var background = SKSpriteNode(imageNamed: "water")
    var scoreLabel = SKLabelNode(fontNamed: "Copperplate")
    
    var bubblesFrames: [SKTexture] = []
    
    static var score = 0
    var health = 3
    
    
    
    override func didMove(to view: SKView) {
        scoreLabel.text = "Score: \(GameScene.score)"
        scoreLabel.fontColor = SKColor.white
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: size.width/9, y: size.height)
        addChild(scoreLabel)
        
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.size = CGSize(width: frame.width, height:frame.height)
        background.zPosition = -1
        submarine.position = CGPoint(x: size.width * 0.12, y: size.height * 0.5)
        submarine.size = CGSize(width: frame.width * 0.15, height:frame.height * 0.15)
        submarine.physicsBody = SKPhysicsBody(rectangleOf: submarine.size)
        submarine.physicsBody?.isDynamic = false
        submarine.physicsBody?.categoryBitMask = PhysicsCategory.submarine
        submarine.physicsBody?.contactTestBitMask = PhysicsCategory.shark
        addChild(submarine)
        makeAnimation(submarine: submarine)
        addChild(background)
        let ground = SKShapeNode(rect: rect)
        ground.fillColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        addChild(ground)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addShark),
                SKAction.wait(forDuration: 1.0)])))
        
        run(SKAction.repeatForever(
        SKAction.sequence([
            SKAction.run(addAnchor),
            SKAction.wait(forDuration: 10.0)])))
        
        run(SKAction.repeatForever(
               SKAction.sequence([
                   SKAction.run(addStone),
                   SKAction.wait(forDuration: 10.0)])))
        
        run(SKAction.repeatForever(
        SKAction.sequence([
            SKAction.run(addBarrel),
            SKAction.wait(forDuration: 5.0)])))
    }
    
    
    func makeAnimation(submarine: SKSpriteNode){
       let bubblesAnimated = SKTextureAtlas(named: "bubbles")
        var sweamFrames: [SKTexture] = []
        
        let numImages = bubblesAnimated.textureNames.count
        for i in 1...numImages{
            let bubbleTextureName = "bubble\(i)"
            sweamFrames.append(bubblesAnimated.textureNamed(bubbleTextureName))
        }
        bubblesFrames = sweamFrames
        let firstFrameTexture = bubblesFrames[0]
        
        let bubble = SKSpriteNode(texture: firstFrameTexture)
        bubble.size = CGSize(width: frame.width*0.1, height: frame.height*0.1)
        bubble.position = CGPoint(x: submarine.position.x - 110 , y: submarine.position.y - 180)
        
        submarine.addChild(bubble)
       // let moveBubbles = SKAction.moveBy(x: submarine.position.x - 2, y: submarine.position.y, duration: 0.5)
        
        bubble.run(SKAction.repeatForever(SKAction.sequence([SKAction.animate(with: bubblesFrames, timePerFrame: 0.3, resize: false, restore: true)])))
        
    }
    
    
    
    func random()-> CGFloat{
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat)-> CGFloat{
      return random() * (max - min) + min
    }
    
    
    func addAnchor(){
        let anchor = SKSpriteNode(imageNamed: "Anchor")
        anchor.size = CGSize(width: frame.width * 0.15, height:frame.height * 0.15)
        anchor.position = CGPoint(x: size.width + anchor.size.width / 2, y: size.height - anchor.size.height/2)
        
        addChild(anchor)
        
        let moveAnchor = SKAction.move(to: CGPoint(x: -anchor.size.width/2, y: size.height - anchor.size.height/2), duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        let wait = SKAction.wait(forDuration: Double.random(in: 5.0...10.0))
        anchor.run(SKAction.sequence([wait, moveAnchor, actionDone]))
        
        anchor.physicsBody = SKPhysicsBody(rectangleOf: anchor.size)
        anchor.physicsBody?.isDynamic = true
        anchor.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        anchor.physicsBody?.contactTestBitMask = PhysicsCategory.submarine
        anchor.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    
    func addStone(){
        let stone = SKSpriteNode(imageNamed: "Stone")
        stone.size = CGSize(width: frame.width * 0.3, height:frame.height * 0.3)
        stone.position = CGPoint(x: size.width + stone.size.width / 2, y: rect.size.height)
        
        addChild(stone)
        
        let moveStone = SKAction.move(to: CGPoint(x: -stone.size.width/2, y: rect.size.height), duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        let wait = SKAction.wait(forDuration: Double.random(in: 5.0...10.0))
        stone.run(SKAction.sequence([wait, moveStone, actionDone]))
        
        stone.physicsBody = SKPhysicsBody(rectangleOf: stone.size)
        stone.physicsBody?.isDynamic = true
        stone.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        stone.physicsBody?.contactTestBitMask = PhysicsCategory.submarine
        stone.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    
    func addShark(){
      let shark = SKSpriteNode(imageNamed: "shark")
      shark.size = CGSize(width:frame.width*0.1, height: frame.height*0.1)
      let actualY = random(min: shark.size.height/2, max: size.height - shark.size.height/2)
      shark.position = CGPoint(x: size.width + shark.size.width / 2, y: actualY)
      addChild(shark)
      
      let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
      let actionMove = SKAction.move(to: CGPoint(x: -shark.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
      let actionDone = SKAction.removeFromParent()
      shark.run(SKAction.sequence([actionMove, actionDone]))
      
        shark.physicsBody = SKPhysicsBody(rectangleOf: shark.size)
      shark.physicsBody?.isDynamic = true
      shark.physicsBody?.categoryBitMask = PhysicsCategory.shark
      shark.physicsBody?.contactTestBitMask = PhysicsCategory.submarine
      shark.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    
    func addBarrel(){
        let barrel = SKSpriteNode(imageNamed: "Barrel")
        barrel.size = CGSize(width: frame.width * 0.1, height: frame.height * 0.1)
        barrel.position = CGPoint(x: size.width + barrel.size.width / 2, y: rect.size.height + barrel.size.height/2)
        addChild(barrel)
        
        let moveBarrel = SKAction.move(to: CGPoint(x: -barrel.size.width/2, y: rect.size.height + barrel.size.height/2), duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        let wait = SKAction.wait(forDuration: Double.random(in: 5.0...15.0))
        barrel.run(SKAction.sequence([wait, moveBarrel, actionDone]))
        
        barrel.physicsBody = SKPhysicsBody(rectangleOf: barrel.size)
        barrel.physicsBody?.isDynamic = true
        barrel.physicsBody?.categoryBitMask = PhysicsCategory.barrel
        barrel.physicsBody?.contactTestBitMask = PhysicsCategory.missile
        barrel.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    
    func addBrokenBarrel(barrel: SKSpriteNode){
        let brokenBarrel = SKSpriteNode(imageNamed: "Barrel2")
        brokenBarrel.size = CGSize(width: frame.width * 0.1, height: frame.height * 0.1)
        brokenBarrel.position = barrel.position
        addChild(brokenBarrel)
        
        let moveBarrel = SKAction.move(to: CGPoint(x: -brokenBarrel.size.width/2, y: rect.size.height + barrel.size.height/2), duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        brokenBarrel.run(SKAction.sequence([moveBarrel, actionDone]))
    }
    
    func addBonus(barrel: SKSpriteNode){
        let healthBonus = SKSpriteNode(imageNamed: "health")
        let scoreBonus = SKSpriteNode(imageNamed: "score")
        healthBonus.size = CGSize(width: frame.width * 0.05, height: frame.height * 0.05)
        scoreBonus.size = CGSize(width: frame.width * 0.05, height: frame.height * 0.05)
        healthBonus.position = barrel.position
        scoreBonus.position = barrel.position
        let moveUp = SKAction.move(to: CGPoint(x: barrel.position.x, y: barrel.size.height + 1), duration: 0.5)
        let move = SKAction.move(to: CGPoint(x: -barrel.size.width/2, y: barrel.size.height + 1), duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        
        healthBonus.physicsBody = SKPhysicsBody(rectangleOf: healthBonus.size)
        healthBonus.physicsBody?.isDynamic = true
        healthBonus.physicsBody?.categoryBitMask = PhysicsCategory.health
        healthBonus.physicsBody?.contactTestBitMask = PhysicsCategory.submarine
        scoreBonus.physicsBody = SKPhysicsBody(rectangleOf: scoreBonus.size)
        scoreBonus.physicsBody?.isDynamic = true
        scoreBonus.physicsBody?.categoryBitMask = PhysicsCategory.score
        scoreBonus.physicsBody?.contactTestBitMask = PhysicsCategory.submarine
        
        switch arc4random_uniform(2) {
        case 0:
            self.addChild(healthBonus)
            healthBonus.run(SKAction.sequence([moveUp, move, actionDone]))
        case 1:
            self.addChild(scoreBonus)
            scoreBonus.run(SKAction.sequence([moveUp, move, actionDone]))
        default: print("nothing")
        }
    }
    
    func distanceBetweenPoints(a: CGPoint, b: CGPoint) -> CGFloat {
        return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }
      
      let touchLocation = touch.location(in: self)
      
      let missile = SKSpriteNode(imageNamed: "missile")
      missile.position = submarine.position
        missile.size = CGSize(width: frame.width * 0.1, height: frame.height * 0.1)
      
      let offset = touchLocation - missile.position
      
      addChild(missile)
        
      if offset.x < 0 || offset.x < size.width*0.1{
        let newPlayerPosition = touchLocation
        let speed: CGFloat = 500
        let distance = distanceBetweenPoints(a: submarine.position, b: touchLocation)
        let playerMove = SKAction.move(to: newPlayerPosition, duration: TimeInterval(distance/speed))
        submarine.run(playerMove)
        missile.removeFromParent()
      }
      
      
      let direction = offset.normalized()
      let shootAmount = direction * 1000
      let realDest = shootAmount + missile.position
      let actionMove = SKAction.move(to: realDest, duration: 2.0)
      let actionMoveDone = SKAction.removeFromParent()
      missile.run(SKAction.sequence([actionMove, actionMoveDone]))
      
      missile.physicsBody = SKPhysicsBody(circleOfRadius: missile.size.height/2)
      missile.physicsBody?.isDynamic = true
      missile.physicsBody?.categoryBitMask = PhysicsCategory.missile
      missile.physicsBody?.contactTestBitMask = PhysicsCategory.shark
      missile.physicsBody?.collisionBitMask = PhysicsCategory.none
      missile.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    func missileDidCollideWithShark(missile: SKSpriteNode, shark: SKSpriteNode){
        missile.removeFromParent()
        shark.removeFromParent()
        GameScene.score += 2
        scoreLabel.text = "Score: \(GameScene.score)"
    }
    
    func blinc(submarine: SKSpriteNode){
        let changeAlpha: SKAction = SKAction.run { () -> Void in
            submarine.alpha = 0.5
        }
        
        let changeBack: SKAction = SKAction.run { () -> Void in
            submarine.alpha = 1.0
        }
        
        let wait: SKAction = SKAction.wait(forDuration: 0.5)
        
        let sequence: SKAction = SKAction.sequence([changeAlpha,wait,changeBack,wait,changeAlpha,changeBack])
        
        run(sequence)
    }
   
    
    func submarineDidCollideWithShark(shark: SKSpriteNode, submarine: SKSpriteNode){
        shark.removeFromParent()
        health -= 1
        blinc(submarine: submarine)
        if health == 0{
        let loseAction = SKAction.run() {
          [weak self] in
          guard let `self` = self else {return}
          let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
          let gameOverScene = GameOverScene(size: self.size, won: false)
          self.view?.presentScene(gameOverScene, transition: reveal)
        }
         run(loseAction)
        }
    }
    
    
   func submarineDidColliseWithObstacle(submarine: SKSpriteNode){
        health -= 1
        blinc(submarine: submarine)
        if health == 0{
            let loseAction = SKAction.run() {
              [weak self] in
              guard let `self` = self else {return}
              let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
              let gameOverScene = GameOverScene(size: self.size, won: false)
              self.view?.presentScene(gameOverScene, transition: reveal)
            }
            run(loseAction)
        }
    }
    
    
    func missileDidCollideWithBarrel(missile: SKSpriteNode, barrel: SKSpriteNode){
        missile.removeFromParent()
        barrel.removeFromParent()
        addBrokenBarrel(barrel: barrel)
        addBonus(barrel: barrel)
    }
    
    func submarineDidCollideWithHealthBonus(submarine: SKSpriteNode, bonusHealth: SKSpriteNode){
        bonusHealth.removeFromParent()
        health += 1
    }
    
    func submarineDidCollideWithScoreBonus(submarine: SKSpriteNode, bonusScore: SKSpriteNode){
        bonusScore.removeFromParent()
        GameScene.score += 10
        scoreLabel.text = "Score: \(GameScene.score)"
    }
    
}


extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
          firstBody = contact.bodyA
          secondBody = contact.bodyB
        } else {
          firstBody = contact.bodyB
          secondBody = contact.bodyA
        }
    
        if ((firstBody.categoryBitMask == 1) && (secondBody.categoryBitMask == 4)){
            if let shark = firstBody.node as? SKSpriteNode,
                let missile = secondBody.node as? SKSpriteNode{
                missileDidCollideWithShark(missile: missile, shark: shark)
                print(PhysicsCategory.shark)
                print(PhysicsCategory.missile)
                print("missile with shark")
            }
        }
        
        if ((firstBody.categoryBitMask == 1) && (secondBody.categoryBitMask == 5)){
            if let shark = firstBody.node as? SKSpriteNode,
                let submarine = secondBody.node as? SKSpriteNode{
                submarineDidCollideWithShark(shark: shark, submarine: submarine)
                print(PhysicsCategory.shark)
                print(PhysicsCategory.submarine)
                print("sub with shark")
            }
        }
        
        if ((firstBody.categoryBitMask == 2) && (secondBody.categoryBitMask == 5)){
            if let obstacle = firstBody.node as? SKSpriteNode,
                let submarine = secondBody.node as? SKSpriteNode{
                submarineDidColliseWithObstacle(submarine: submarine)
                print(PhysicsCategory.obstacle)
                print(PhysicsCategory.submarine)
                print("sub with obs")
            }
        }
        
        if ((firstBody.categoryBitMask == 3) && (secondBody.categoryBitMask == 4)){
            if let barrel = firstBody.node as? SKSpriteNode,
                let missile = secondBody.node as? SKSpriteNode{
                missileDidCollideWithBarrel(missile: missile, barrel: barrel)
                print(PhysicsCategory.missile)
                print(PhysicsCategory.barrel)
                print("missile with barrel")
            }
        }
        
        if ((firstBody.categoryBitMask == 5) && (secondBody.categoryBitMask == 6)){
            if let submarine = firstBody.node as? SKSpriteNode,
                let health = secondBody.node as? SKSpriteNode{
                submarineDidCollideWithHealthBonus(submarine: submarine, bonusHealth: health)
                print("sub with health")
            }
        }
        
        if ((firstBody.categoryBitMask == 5) && (secondBody.categoryBitMask == 7)){
            if let submarine = firstBody.node as? SKSpriteNode,
                let score = secondBody.node as? SKSpriteNode{
                submarineDidCollideWithScoreBonus(submarine: submarine, bonusScore: score)
                print("sub with score")
            }
        }
        
        
        
        }
        
        
}
    
    
    
    
    
    
    
    
    
    
    





















func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
  func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
  }
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}
