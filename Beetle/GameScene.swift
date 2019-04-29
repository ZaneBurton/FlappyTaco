//
//  GameScene.swift
//  Beetle
//
//  Created by Zane Burton on 4/10/19.
//  Copyright © 2019 Zane Burton. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //TESTING FOR NEW BRANCH
    
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var capturedLettuce = Int(0)
    
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var youSuckImg = SKSpriteNode()
    var lettuceLbl = SKLabelNode()
    
    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<Any>()
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false{
            //1
            isGameStarted =  true
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            //2
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            //3
            self.bird.run(repeatActionBird)
            
            //TODO: add pillars here
            //1
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            //2
            let delay = SKAction.wait(forDuration: 2.0) //1.5
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            //3
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
            
            print("you are where the walls are getting created the first time")
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        } else {
            //4
            if isDied == false {
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        for touch in touches{
            let location = touch.location(in: self)
            //1
            if isDied == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            } else {
                //2
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    
    func bringBackToNormal () {
        
        wallPair.removeFromParent()
        self.removeAction(forKey: "spawn")
        self.removeAction(forKey: "delay")
        self.removeAction(forKey: "SpawnDelay")
        self.removeAction(forKey: "spawnDelayForever")
        self.removeAction(forKey: "movePillars")
        self.removeAction(forKey: "removePillars")
        self.removeAction(forKey: "moveAndRemove")
        
        
        let spawn = SKAction.run({
            () in
            self.wallPair = self.createWalls()
            self.addChild(self.wallPair)
        })
        let delay = SKAction.wait(forDuration: 1.5) //1.5
        let SpawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
        self.run(spawnDelayForever)
        //3
        let distance2 = CGFloat(self.frame.width + wallPair.frame.width)
        let movePillars = SKAction.moveBy(x: -distance2 - 50, y: 0, duration: TimeInterval(0.008 * distance2))
        let removePillars = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([movePillars, removePillars])
    }
    
    func makeGameHarder () {
        
        let distance = CGFloat(self.frame.width + wallPair.frame.width)
        let movePillars = SKAction.moveBy(x: -distance - 300, y: 0, duration: TimeInterval(0.008 * distance))
        let removePillars = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([movePillars, removePillars])
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isGameStarted == true{
            if isDied == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
            }
        }
    }
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("taco1"))
        birdSprites.append(birdAtlas.textureNamed("taco1"))
        birdSprites.append(birdAtlas.textureNamed("taco1"))
        birdSprites.append(birdAtlas.textureNamed("taco1"))
        
        self.bird = createBird()
        self.addChild(bird)
        
        //PREPARE TO ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animateBird = SKAction.animate(with: self.birdSprites as! [SKTexture], timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        lettuceLbl = createLettuceLabel()
        self.addChild(lettuceLbl)
        
        createLogo()
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
        
        

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.lettuceCategory {
            capturedLettuce += 1
            lettuceLbl.text = "Lettuce: \(capturedLettuce)"

            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.lettuceCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            capturedLettuce += 1
            lettuceLbl.text = "Lettuce: \(capturedLettuce)"

            firstBody.node?.removeFromParent()
        }
        
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory{
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDied == false{
                isDied = true
                createRestartBtn()
                createYouSuckLogo()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(coinSound)
            score += 1
            if score > 1 && score < 4 {
                //makeGameHarder()
            } else if score > 4  && score < 6{
               print("Here")
               //bringBackToNormal()
            }
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            score += 1
            if score > 1 && score < 4 {
                //makeGameHarder()
            } else if score > 4 &&  score < 6{
                print("Here2")
               // bringBackToNormal()
            }
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    func restartScene(){
       /* taptoplayLbl.removeFromParent()
        bird.removeFromParent()
        highscoreLbl.removeFromParent()
        scoreLbl.removeFromParent()
        restartBtn.removeFromParent()
        pauseBtn.removeFromParent()
        logoImg.removeFromParent()
        wallPair.removeFromParent()
        youSuckImg.removeFromParent()
    */
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        createScene()
    }
    
    
}
