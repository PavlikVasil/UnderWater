//
//  GameOverScene.swift
//  UnderWater
//
//  Created by Павел on 11/17/20.
//  Copyright © 2020 Павел. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
  
  init(size: CGSize, won: Bool){
    super.init(size: size)

  backgroundColor = SKColor.black
  
  let message = "You lose"
  
    let label = SKLabelNode(fontNamed: "Copperplate")
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.red
    label.position = CGPoint(x: size.width/2, y: size.height/2)
    addChild(label)
    
    let score = GameScene.shared.score
    let scoreLabel = SKLabelNode(fontNamed: "Copperplate")
    scoreLabel.text = "Score: \(score)"
    scoreLabel.fontColor = SKColor.white
    scoreLabel.position = CGPoint(x: size.width/2, y: size.height/3)
    addChild(scoreLabel)
    
    run(SKAction.sequence([SKAction.wait(forDuration: 2.0),
                           SKAction.run {
                            [weak self] in
                            guard let `self` = self else {return}
                            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                            let scene = GameScene(size: size)
                            self.view?.presentScene(scene, transition: reveal)
      }
    
    ]))
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
