//
//  GameScene.swift
//  MemoryGame
//
//  Created by Nicole Nowicki on 2019-09-11.
//  Copyright © 2019 Nicole Nowicki. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: GameScene

class GameScene: SKScene {
    
    // MARK: Internal
    
    override func update(_ currentTime: TimeInterval) { }
    
    override func didMove(to view: SKView) {
        
        // Initialize Loading Spinner
        
        loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        loadingSpinner.stopAnimating()
        loadingSpinner.hidesWhenStopped = true
        view.addSubview(self.loadingSpinner)
        
        presentMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        let startGameSequence = SKAction.sequence([
            SKAction.scale(to: 1.0, duration: 0.5),
            SKAction.wait(forDuration: 0.5)])
        
        if touchedNode.name == "easy" && !gameStarted {
            numberOfCards = 10
            numberOfCardsRow = 4
            matchThree = false
            gameStarted = true
            
            easyLabel.run(SKAction.scale(to: 0.0, duration: 0.3)) {
                self.easyLabel.text = "Match 10 Pairs to Win"
                self.easyLabel.run(startGameSequence) {
                    self.hideMenu()
                    self.initializeScore()
                    self.fetchCards()
                }
            }
        } else if touchedNode.name == "medium" && !gameStarted {
            numberOfCards = 15
            numberOfCardsRow = 5
            matchThree = false
            gameStarted = true
            
            mediumLabel.run(SKAction.scale(to: 0.0, duration: 0.3)) {
                self.mediumLabel.text = "Match 15 Pairs to Win"
                self.mediumLabel.run(startGameSequence) {
                    self.hideMenu()
                    self.initializeScore()
                    self.fetchCards()
                }
            }
        } else if touchedNode.name == "hard" && !gameStarted {
            numberOfCards = 10
            numberOfCardsRow = 5
            matchThree = true
            gameStarted = true
            
            hardLabel.run(SKAction.scale(to: 0.0, duration: 0.3)) {
                self.hardLabel.text = "Match 10 Triples to Win"
                self.hardLabel.run(startGameSequence) {
                    self.hideMenu()
                    self.initializeScore()
                    self.fetchCards()
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
    
    // MARK: Private
    
    // Menu Elements
    
    private var titleLabel: SKLabelNode!
    private var easyLabel: SKLabelNode!
    private var mediumLabel: SKLabelNode!
    private var hardLabel: SKLabelNode!
    
    // Gameview Elements
    
    private var scoreLabel: SKLabelNode!
    private var winnerLabel: SKLabelNode!
    
    private var gameStarted: Bool = false
    
    private var productImages: [ProductImage] = []
    private var cards: [Card] = []
    private var cardsFlipped: [Card] = []
    
    private var currentScore = 0
    private var numberOfCards: Int = 10
    
    private var matchThree: Bool = false
    private var numberOfCardsRow: Int = 4
    
    private var loadingSpinner: UIActivityIndicatorView!
    private var snowAnimation: [SKSpriteNode] = []
    
    // End Game Elements
    
    private var endGameLabel: SKLabelNode!
    private var returnToMenuLabel: SKLabelNode!
    
    private func presentMenu() {
        titleLabel = SKLabelNode(fontNamed: "Helvetica")
        titleLabel.text = "MEMORY GAME"
        titleLabel.fontSize = 70
        titleLabel.position = CGPoint(x: 0, y: 100)
        self.addChild(titleLabel)
        
        titleLabel.setScale(0)
        titleLabel.isHidden = false
        titleLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        easyLabel = SKLabelNode(fontNamed: "Helvetica")
        easyLabel.text = "EASY"
        easyLabel.fontSize = 50
        easyLabel.position = CGPoint(x: 0, y: titleLabel.position.y - 150)
        easyLabel.name = "easy"
        self.addChild(easyLabel)
        
        easyLabel.setScale(0)
        easyLabel.isHidden = false
        easyLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        mediumLabel = SKLabelNode(fontNamed: "Helvetica")
        mediumLabel.text = "MEDIUM"
        mediumLabel.fontSize = 50
        mediumLabel.position = CGPoint(x: 0, y: easyLabel.position.y - 100)
        mediumLabel.name = "medium"
        self.addChild(mediumLabel)
        
        mediumLabel.setScale(0)
        mediumLabel.isHidden = false
        mediumLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        hardLabel = SKLabelNode(fontNamed: "Helvetica")
        hardLabel.text = "HARD"
        hardLabel.fontSize = 50
        hardLabel.position = CGPoint(x: 0, y: mediumLabel.position.y - 100)
        hardLabel.name = "hard"
        self.addChild(hardLabel)
        
        hardLabel.setScale(0)
        hardLabel.isHidden = false
        hardLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        gameStarted = false
    }
    
    private func hideMenu() {
        titleLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.titleLabel.isHidden = false
        }
        
        easyLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.easyLabel.isHidden = false
        }
        
        mediumLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.mediumLabel.isHidden = false
        }
        
        hardLabel.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.hardLabel.isHidden = false
            self.loadingSpinner.startAnimating()
        }
    }
    
    private func fetchCards() {
        productImages = []
        let jsonURL = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        
        guard let url = URL(string: jsonURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error)  in
            guard let data = data else { return }
            do {
                let decodedJSON = try JSONDecoder().decode(Products.self, from: data)
                let products = decodedJSON.products
                
                // Initialize list of product images to be used
                
                for i in 0...(self.numberOfCards - 1) {
                    
                    // Append twice (or three times) to produce matches
                    
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
                self.presentMenu()
            }
        }.resume()
    }
    
    private func initializeCards() {
        
        // Spacing constants
        
        let widthSpacing: CGFloat = 30
        let widthPadding: CGFloat = 80
        let heightSpacing: CGFloat = 30
        
        // Size of cards calculation
        
        let totalWidth: CGFloat = size.width - widthPadding - widthSpacing*(CGFloat(integerLiteral: numberOfCardsRow + 1))
        var sizeOfCards: CGFloat = totalWidth/CGFloat(integerLiteral: numberOfCardsRow)
        var heightPadding = size.height -
            sizeOfCards*(CGFloat(integerLiteral: numberOfCards/2)) -
            heightSpacing*(CGFloat(integerLiteral: numberOfCards/2))
            
        
        // Special case: match three
        
        if matchThree {
            sizeOfCards = (size.width - widthPadding -
                widthSpacing*(CGFloat(integerLiteral: numberOfCardsRow + 1)))/(CGFloat(integerLiteral: numberOfCardsRow))
            heightPadding = size.height -
                sizeOfCards*(CGFloat(integerLiteral: numberOfCardsRow + 1)) -
                heightSpacing*(CGFloat(integerLiteral: numberOfCardsRow + 1))
        }
        
        var previousX: CGFloat = (size.width / -2) + widthPadding*0.5 + sizeOfCards*0.5 + widthSpacing
        var previousY: CGFloat = (size.height / -2) + heightPadding*0.5
        var currentImage = 0
        cards = []
        cardsFlipped = []
        
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
                
                // Start a new row
                
                if (currentImage % numberOfCardsRow == 0) {
                    previousY = previousY + sizeOfCards + heightSpacing
                    previousX = (self.size.width / -2) + widthPadding*0.5 + sizeOfCards*0.5 + widthSpacing
                }
                
                currentImage += 1
                
                // Update position
                
                card.position = CGPoint(x: previousX, y: previousY)
                previousX = previousX + sizeOfCards + widthSpacing
                
                card.isHidden = false
                card.setScale(0)
                
                cards.append(card)
                self.addChild(card)
            } catch {
                presentMenu()
            }
        }
        
        // Display all cards at once
        
        for card in cards {
            card.run(SKAction.scale(to: 1.0, duration: 0.3))
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.loadingSpinner.stopAnimating()
        }
    }
    
    private func initializeScore() {
        currentScore = 0
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel?.position = CGPoint(x: 0, y: self.size.height / -2 + 100)
        scoreLabel?.text = "Score \(currentScore)"
        scoreLabel?.color = UIColor.white
        scoreLabel?.fontSize = 40
        self.addChild(scoreLabel)
        
        scoreLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    private func compareCards() {
        let count = cardsFlipped.count
        let sequence = SKAction.sequence([
            SKAction.scale(to: 0.5, duration: 0.3),
            SKAction.scale(to: 1.0, duration: 0.3)])
        
        if !matchThree && cardsFlipped.count > 0 && cardsFlipped.count % 2 == 0 {
            if cardsFlipped[count - 2].id == cardsFlipped[count - 1].id {
                
                // Match found
                
                cardsFlipped[count - 2].run(sequence)
                cardsFlipped[count - 1].run(sequence)
                
                currentScore += 1
                updateScore()
            } else {

                // No match flip cards back
                
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
                
                // Found a match
                
                cardsFlipped[count - 3].run(sequence)
                cardsFlipped[count - 2].run(sequence)
                cardsFlipped[count - 1].run(sequence)
                
                currentScore += 1
                updateScore()
            } else {
                
                // No match flip cards back
                
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
    
    private func updateScore() {
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
    
    private func presentEndGame() {
        
        // Display snowflake animation
        
        for i in 0...24 {
            snowAnimation.append(SKSpriteNode(imageNamed: "freesnowflake"))
            snowAnimation[i].size = CGSize(width: 100, height: 100)
            snowAnimation[i].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            snowAnimation[i].physicsBody?.linearDamping = CGFloat.random(in: 5.0 ..< 15.0)
            self.addChild(snowAnimation[i])
            
            snowAnimation[i].position = CGPoint(
                x: CGFloat.random(in: size.width / -2 ..< size.width / 2),
                y: CGFloat.random(in: size.height / 2 ..< size.height / 2 + 2000))
        }
        
        endGameLabel = SKLabelNode(fontNamed: "Helvetica")
        endGameLabel.text = "YOU WIN!"
        endGameLabel.fontSize = 80
        endGameLabel.position = CGPoint(x: 0, y: 100)
        self.addChild(endGameLabel)
        
        endGameLabel.setScale(0)
        endGameLabel.isHidden = false
        endGameLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
        
        returnToMenuLabel = SKLabelNode(fontNamed: "Helvetica")
        returnToMenuLabel.text = "RETURN TO MENU"
        returnToMenuLabel.fontSize = 60
        returnToMenuLabel.position = CGPoint(x: 0, y: endGameLabel.position.y - 200)
        returnToMenuLabel.name = "return_to_menu"
        self.addChild(returnToMenuLabel)
        
        returnToMenuLabel.setScale(0)
        returnToMenuLabel.isHidden = false
        returnToMenuLabel.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
}
