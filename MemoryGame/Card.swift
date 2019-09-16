//
//  Card.swift
//  MemoryGame
//
//  Created by Nicole Nowicki on 2019-09-12.
//  Copyright © 2019 Nicole Nowicki. All rights reserved.
//

import SpriteKit

class Card: SKSpriteNode {
    let frontImage: SKTexture?
    let backImage: SKTexture?
    var cardFlipped: Bool
    let id: Int
    
    init(id: Int, frontImage: SKTexture?, backImage: SKTexture?, color: UIColor, size: CGSize) {
        self.id = id
        self.frontImage = frontImage
        self.backImage = backImage
        self.cardFlipped = false
        super.init(texture: frontImage, color: color, size: size)
        self.name = "card"
    }
    
    func flipCard() {
        if cardFlipped {
            cardFlipped = false
            self.texture = frontImage
        } else {
            cardFlipped = true
            self.texture = backImage
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


