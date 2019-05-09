//
//  GameElements.swift
//  Beetle
//
//  Created by Zane Burton on 4/10/19.
//  Copyright © 2019 Zane Burton. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
    static let lettuceCategory:UInt32 = 0x1 << 4
    static let cheeseCategory:UInt32 = 0x1 << 5
}

extension GameScene {
    
    
    func createWalls() -> SKNode  {
        // 1
        let flowerNode = SKSpriteNode(imageNamed: "sourCream")
        flowerNode.size = CGSize(width: 75, height: 75)
        flowerNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 30)
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        flowerNode.color = SKColor.blue
        
        
        
        let randomFloat = Float.random(in: 150...200) //25...250
        let lettuceNode = SKSpriteNode(imageNamed: "lettuceLOL")
        lettuceNode.size = CGSize(width: 75, height: 75)
        lettuceNode.position = CGPoint(x: self.frame.width + 175, y: CGFloat(randomFloat))
        lettuceNode.physicsBody = SKPhysicsBody(rectangleOf: lettuceNode.size)
        lettuceNode.physicsBody?.affectedByGravity = false
        lettuceNode.physicsBody?.isDynamic = false
        lettuceNode.physicsBody?.categoryBitMask = CollisionBitMask.lettuceCategory
        lettuceNode.physicsBody?.collisionBitMask = 0
        lettuceNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        
        let randomCheeseFloat = Float.random(in: 400...550)//275...350
        let cheeseNode = SKSpriteNode(imageNamed: "cheese1")
        cheeseNode.size = CGSize(width: 75, height: 75)
        cheeseNode.position = CGPoint(x: self.frame.width + 175, y: CGFloat(randomCheeseFloat))
        cheeseNode.physicsBody = SKPhysicsBody(rectangleOf: cheeseNode.size)
        cheeseNode.physicsBody?.affectedByGravity = false
        cheeseNode.physicsBody?.isDynamic = false
        cheeseNode.physicsBody?.categoryBitMask = CollisionBitMask.cheeseCategory
        cheeseNode.physicsBody?.collisionBitMask = 0
        cheeseNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        
        // 2
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "pillar")
        let btmWall = SKSpriteNode(imageNamed: "pillar")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 370) //370
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        // 3
        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(flowerNode)
        if gameMode == false {
            wallPair.addChild(lettuceNode)
            wallPair.addChild(cheeseNode)
        }
        wallPair.run(moveAndRemove)
        
        return wallPair
    }
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    func createBird() -> SKSpriteNode {
        //1
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("taco1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        //2
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        //3
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory | CollisionBitMask.lettuceCategory | CollisionBitMask.cheeseCategory
        //4
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    //1
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createEndlessMode() {
        endlessBtn = SKSpriteNode(imageNamed: "endlessMode1")
        endlessBtn.size = CGSize(width:150, height:100)
        endlessBtn.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 250)
        endlessBtn.zPosition = 6
        self.addChild(endlessBtn)
    }
    //2
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    //3
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    
    func createLettuceLabel() -> SKLabelNode {
        let lettuceLbl = SKLabelNode()
        lettuceLbl.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 2 + self.frame.height / 2.6)
        lettuceLbl.zPosition = 5
        lettuceLbl.fontSize = 12
        lettuceLbl.fontColor = UIColor.black
        lettuceLbl.fontName = "HelveticaNeue-Bold"
        
        lettuceLbl.position = CGPoint(x: self.frame.width - 335, y: self.frame.height - 22)
        lettuceLbl.text = "Lettuce: "
        
        return lettuceLbl
    }
    
    func createCheeseLabel() -> SKLabelNode {
        let cheeseLbl = SKLabelNode()
       // cheeseLbl.position = CGPoint(x: self.frame.width / 4, y: self.frame.height / 2 + self.frame.height / 2.8)
        cheeseLbl.zPosition = 5
        cheeseLbl.fontSize = 12
        cheeseLbl.fontColor = UIColor.black
        cheeseLbl.fontName = "HelveticaNeue-Bold"
        
        cheeseLbl.position = CGPoint(x: self.frame.width - 335, y: self.frame.height - 45)
        cheeseLbl.text = "Cheese: "
        
        return cheeseLbl
        
    }
    //4
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    //5
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "newLogo")
        logoImg.size = CGSize(width: 272, height: 65)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    //6
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    
    func createYouSuckLogo() {
        youSuckImg = SKSpriteNode()
        youSuckImg = SKSpriteNode(imageNamed: "youSuck")
        youSuckImg.size = CGSize(width: 272, height: 65)
        youSuckImg.position = CGPoint(x:self.frame.width / 2, y:self.frame.height / 2 - 150)
        youSuckImg.zPosition = 9
        youSuckImg.setScale(0.5)
        self.addChild(youSuckImg)
        youSuckImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createYouWinLogo() {
        youWinImg = SKSpriteNode()
        youWinImg = SKSpriteNode(imageNamed: "youWin")
        youWinImg.size = CGSize(width: 295, height: 80)
        youWinImg.position = CGPoint(x:self.frame.width / 2, y:self.frame.height / 2 - 150)
        youWinImg.zPosition = 9
        youWinImg.setScale(0.8)
        self.addChild(youWinImg)
        youWinImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
   /* func youSuck() -> SKLabelNode {
        let youSuckLbl = SKLabelNode()
        youSuckLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 150)
        youSuckLbl.text = "You suck."
        youSuckLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        youSuckLbl.zPosition = 25
        self.addChild(youSuckLbl)
        return youSuckLbl
    }*/
}
