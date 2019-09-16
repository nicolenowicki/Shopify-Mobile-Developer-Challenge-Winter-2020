//
//  GameScene.swift
//  MemoryGame
//
//  Created by Nicole Nowicki on 2019-09-11.
//  Copyright © 2019 Nicole Nowicki. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // menu elements
    
    private var titleLabel: SKLabelNode!
    private var difficultLabel: SKLabelNode!
    private var slightlyMoreDifficultLabel: SKLabelNode!
    private var matchThreeLabel: SKLabelNode!
    
    // gameview elements
    
    private var scoreLabel: SKLabelNode!
    private var winnerLabel: SKLabelNode!
    
    private var productImages: [ProductImage] = []
    private var cards: [Card] = []
    private var cardsFlipped: [Card] = []
    
    private var currentScore = 0
    private var numberOfCards: Int = 10
    
    private var matchThree: Bool = false
    private var numberOfCardsRow: Int = 4
    
    private var loadingSpinner: UIActivityIndicatorView!
    
    private var snowAnimation: [SKSpriteNode] = []
    
    // end game elements
    
    private var endGameLabel: SKLabelNode!
    private var returnToMenuLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        loadingSpinner.stopAnimating()
        loadingSpinner.hidesWhenStopped = true
        view.addSubview(self.loadingSpinner)
        
        presentMenu()
    }
    
    override func update(_ currentTime: TimeInterval) { }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        if touchedNode.name == "difficult" {
            numberOfCards = 10
            matchThree = false
            numberOfCardsRow = 4
            difficultLabel.run(SKAction.scale(to: 0.0, duration: 0.3)) {
                self.difficultLabel.text = "Match 10 Pairs to Win"
                self.difficultLabel.run(SKAction.scale(to: 1.0, duration: 0.5)) {
                    self.difficultLabel.run(SKAction.wait(forDuration: 0.5)) {
                        self.hideMenu()
                        self.initializeScore()
                        self.fetchCards()
                    }
                }
            }
        } else if touchedNode.name == "slightly_more_difficult" {
            numberOfCards = 15
            matchThree = false
            numberOfCardsRow = 5
            slightlyMoreDifficultLabel.run(SKAction.scale(to: 0.0, duration: 0.3)) {
                self.slightlyMoreDifficultLabel.text = "Match 16 Pairs to Win"
                self.slightlyMoreDifficultLabel.run(SKAction.scale(to: 1.0, duration: 0.5)) {
                    self.slightlyMoreDifficultLabel.run(SKAction.wait(forDuration: 0.5)) {
                        self.hideMenu()
                        self.initializeScore()
                        self.fetchCards()
                    }
                }
            }
        } else if touchedNode.name == "match_three" {
            numberOfCards = 10
            matchThree = true
            numberOfCardsRow = 5
            matchThreeLabel.run(SKAction.scale(to: 0.0, duration: 0.3)) {
                self.matchThreeLabel.text = "Match 10 Triples to Win"
                self.matchThreeLabel.run(SKAction.scale(to: 1.0, duration: 0.5)) {
                    self.matchThreeLabel.run(SKAction.wait(forDuration: 0.5)) {
                        self.hideMenu()
                        self.initializeScore()
                        self.fetchCards()
                    }
                }
            }
        } else if touchedNode.name == "card" {
            guard let frontTouchedNode = atPoint(location) as? Card else { return }
            
            if !frontTouchedNode.cardFlipped {
                frontTouchedNode.flipCard()
                cardsFlipped.append(frontTouchedNode)
                compareCards()
            }
        } else if touchedNode.name == "return_to_menu" {
            removeChildren(in: snowAnimation)
            snowAnimation.removeAll()
            
            endGameLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
                self.removeChildren(in: [self.endGameLabel])
            }
            returnToMenuLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
                self.removeChildren(in: [self.returnToMenuLabel])
                self.presentMenu()
            }
        }
    }
    
    func presentMenu() {
        titleLabel = SKLabelNode(fontNamed: "Helvetica")
        titleLabel.text = "MEMORY GAME"
        titleLabel.fontSize = 70
        titleLabel.position = CGPoint(x: 0, y: 100)
        self.addChild(titleLabel)
        
        titleLabel.setScale(0)
        titleLabel.isHidden = false
        titleLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        difficultLabel = SKLabelNode(fontNamed: "Helvetica")
        difficultLabel.text = "EASY"
        difficultLabel.fontSize = 50
        difficultLabel.position = CGPoint(x: 0, y: titleLabel.position.y - 150)
        difficultLabel.name = "difficult"
        self.addChild(difficultLabel)
        
        difficultLabel.setScale(0)
        difficultLabel.isHidden = false
        difficultLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        slightlyMoreDifficultLabel = SKLabelNode(fontNamed: "Helvetica")
        slightlyMoreDifficultLabel.text = "MEDIUM"
        slightlyMoreDifficultLabel.fontSize = 50
        slightlyMoreDifficultLabel.position = CGPoint(x: 0, y: difficultLabel.position.y - 100)
        slightlyMoreDifficultLabel.name = "slightly_more_difficult"
        self.addChild(slightlyMoreDifficultLabel)
        
        slightlyMoreDifficultLabel.setScale(0)
        slightlyMoreDifficultLabel.isHidden = false
        slightlyMoreDifficultLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        matchThreeLabel = SKLabelNode(fontNamed: "Helvetica")
        matchThreeLabel.text = "HARD"
        matchThreeLabel.fontSize = 50
        matchThreeLabel.position = CGPoint(x: 0, y: slightlyMoreDifficultLabel.position.y - 100)
        matchThreeLabel.name = "match_three"
        self.addChild(matchThreeLabel)
        
        matchThreeLabel.setScale(0)
        matchThreeLabel.isHidden = false
        matchThreeLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func hideMenu() {
        titleLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.titleLabel.isHidden = false
        }
        
        difficultLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.difficultLabel.isHidden = false
        }
        
        slightlyMoreDifficultLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.slightlyMoreDifficultLabel.isHidden = false
        }
        
        matchThreeLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.matchThreeLabel.isHidden = false
            self.loadingSpinner.startAnimating()
        }
    }
    
    func fetchCards() {
        let jsonURL = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: jsonURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error)  in
            guard let data = data else { return }
            
            do {
                let decodedJSON = try JSONDecoder().decode(Products.self, from: data)
                let products = decodedJSON.products
                
                // initialize list of product images to be used
                
                for i in 0...(self.numberOfCards - 1) {
                    
                    // append twice because we need a match
                    
                    guard let image = products[i].image else { continue }
                    
                    self.productImages.append(image)
                    self.productImages.append(image)
                    
                    if self.matchThree {
                        self.productImages.append(image)
                    }
                }
                self.productImages.shuffle()
                self.initializeCards()
            } catch {
                print("error")
            }
        }.resume()
    }
    
    func initializeCards() {
        // spacing constants
        let widthSpacing: CGFloat = 30
        var widthPadding: CGFloat = 50
        let heightSpacing: CGFloat = 30
        var heightPadding: CGFloat = 200
        
        let heightOfCards: CGFloat =
            (self.size.height - heightPadding - heightSpacing*(CGFloat(integerLiteral: (numberOfCards/2))))/CGFloat(integerLiteral: (numberOfCards/2))
        let widthOfCards: CGFloat =
            (self.size.width - widthPadding - widthSpacing*(CGFloat(integerLiteral: numberOfCardsRow + 1)))/(CGFloat(integerLiteral: numberOfCardsRow))
        var sizeOfCards: CGFloat = 0
        
        if heightOfCards > widthOfCards {
            sizeOfCards = widthOfCards
            
            heightPadding = self.size.height - sizeOfCards*(CGFloat(floatLiteral: CGFloat.NativeType(numberOfCards/2))) - heightSpacing*(CGFloat(floatLiteral: CGFloat.NativeType(numberOfCards/2)))
            
        } else {
            sizeOfCards = heightOfCards
            
            widthPadding = self.size.width - sizeOfCards*(CGFloat(integerLiteral: numberOfCardsRow)) - widthSpacing*(CGFloat(integerLiteral: numberOfCardsRow + 1))
        }
        
        // special case: match three
        
        if matchThree {
            sizeOfCards = (self.size.width - widthPadding - widthSpacing*6)/5 // change
            heightPadding = self.size.height - sizeOfCards*6 - heightSpacing*6
        }
        
        var previousX: CGFloat = (self.size.width / -2) + widthPadding*0.5 + sizeOfCards*0.5 + widthSpacing
        var previousY: CGFloat = (self.size.height / -2) + heightPadding*0.5
        var currentImage = 0
        
        for image in productImages {
            guard let url = URL(string: image.src ?? ""), let id = image.id else { break }
        
            do {
                let data = try Data(contentsOf: url)
                guard let urlImage = UIImage(data: data) else { break }
                let card =
                    Card(
                        id: id,
                        frontImage: SKTexture(imageNamed: "snowflake"),
                        backImage: SKTexture(image: urlImage),
                        color: UIColor.white,
                        size: CGSize(width: sizeOfCards, height: sizeOfCards))
                
                if (currentImage % numberOfCardsRow == 0) {
                    previousY = previousY + sizeOfCards + heightSpacing
                    previousX = (self.size.width / -2) + widthPadding*0.5 + sizeOfCards*0.5 + widthSpacing
                }
                currentImage += 1
                
                card.position = CGPoint(x: previousX, y: previousY)
                previousX = previousX + sizeOfCards + widthSpacing
                
                card.isHidden = false
                card.setScale(0)
                
                cards.append(card)
                self.addChild(card)
            } catch {
                return
            }
        }
        
        for card in cards {
            card.run(SKAction.scale(to: 1.0, duration: 0.3))
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.loadingSpinner.stopAnimating()
        }
    }
    
    func initializeScore() {
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel?.position = CGPoint(x: 0, y: self.size.height / -2 + 100)
        scoreLabel?.text = "Score \(currentScore)"
        scoreLabel?.color = UIColor.white
        scoreLabel?.fontSize = 60
        self.addChild(scoreLabel)
        
        scoreLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func compareCards() {
        let count = cardsFlipped.count
        let scaleDown = SKAction.scale(to: 0.5, duration: 0.3)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
        let sequence = SKAction.sequence([scaleDown, scaleUp])
        
        if !matchThree && cardsFlipped.count > 0 && cardsFlipped.count % 2 == 0 {
            if cardsFlipped[count - 2].id == cardsFlipped[count - 1].id {
               
                // found a match
                
                cardsFlipped[count - 2].run(sequence)
                cardsFlipped[count - 1].run(sequence)
                
                currentScore += 1
                updateScore()
            } else {
                
                // no match
                
                cardsFlipped[count - 2].run(sequence) {
                    self.cardsFlipped[count - 2].flipCard()
                }
                cardsFlipped[count - 1].run(sequence) {
                    self.cardsFlipped[count - 1].flipCard()
                }
            }
        } else if matchThree && cardsFlipped.count > 0 && cardsFlipped.count % 3 == 0 {
            if cardsFlipped[count - 2].id == cardsFlipped[count - 1].id &&
                cardsFlipped[count - 2].id == cardsFlipped[count - 3].id {
                
                // found a match
                
                cardsFlipped[count - 3].run(sequence)
                cardsFlipped[count - 2].run(sequence)
                cardsFlipped[count - 1].run(sequence)
                
                currentScore += 1
                updateScore()
            } else {
                
                // no match
                
                cardsFlipped[count - 3].run(sequence) {
                    self.cardsFlipped[count - 3].flipCard()
                }
                cardsFlipped[count - 2].run(sequence) {
                    self.cardsFlipped[count - 2].flipCard()
                }
                cardsFlipped[count - 1].run(sequence) {
                    self.cardsFlipped[count - 1].flipCard()
                }
            }
        }
    }
    
    func updateScore() {
        scoreLabel.text = "Score \(currentScore)"
        
        if currentScore == numberOfCards {
            for card in cards {
                card.run(SKAction.scale(to: 0, duration: 0.3)) {
                    self.removeChildren(in: [card])
                }
            }
            
            scoreLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
                self.removeChildren(in: [self.scoreLabel])
                self.presentEndGame()
            }
        }
    }
    
    func presentEndGame() {
        for i in 1...25 {
            snowAnimation.append(SKSpriteNode(imageNamed: "freesnowflake"))
            snowAnimation[i - 1].size = CGSize(width: 100, height: 100)
            snowAnimation[i - 1].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            snowAnimation[i - 1].physicsBody?.linearDamping = CGFloat.random(in: 5.0 ..< 15.0)
            self.addChild(snowAnimation[i - 1])
            
            snowAnimation[i - 1].position = CGPoint(
                x: CGFloat.random(in: size.width / -2 ..< size.width / 2),
                y: CGFloat.random(in: size.height / 2 ..< size.height / 2 + 2000))
        }
        
        endGameLabel = SKLabelNode(fontNamed: "Helvetica")
        endGameLabel.text = "YOU WIN!"
        endGameLabel.fontSize = 70
        endGameLabel.position = CGPoint(x: 0, y: 100)
        self.addChild(endGameLabel)
        
        endGameLabel.setScale(0)
        endGameLabel.isHidden = false
        endGameLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        returnToMenuLabel = SKLabelNode(fontNamed: "Helvetica")
        returnToMenuLabel.text = "RETURN TO MENU"
        returnToMenuLabel.fontSize = 50
        returnToMenuLabel.position = CGPoint(x: 0, y: endGameLabel.position.y - 200)
        returnToMenuLabel.name = "return_to_menu"
        self.addChild(returnToMenuLabel)
        
        returnToMenuLabel.setScale(0)
        returnToMenuLabel.isHidden = false
        returnToMenuLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
}
