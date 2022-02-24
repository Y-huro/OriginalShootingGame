//
//  GameScene.swift
//  ShootingGame
//
//  Created by y i on 2022/02/13.
//

import UIKit
//import Foundation
import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {

    var scrollNode:SKNode!
    var flameNode:SKNode!
    var backgroundNode:SKNode!
    var targetNode:SKNode!
    var scoreNode:SKNode!
    var itemNode:SKNode!
    var player:SKSpriteNode!
    var uiButtonNode:SKNode!
    var uiButtonBackLabel:SKLabelNode!

    var itemPlayer:AVAudioPlayer?
    
    // 衝突判定カテゴリー
    let playerCategory: UInt32 = 1 << 0
    let targetCategory: UInt32 = 1 << 1
    let scoreCategory: UInt32 = 1 << 2
    let itemCategory: UInt32 = 1 << 3
    let flameCategory: UInt32 = 1 << 4
    
    // ステージ
    var stage = 0
    var stageLabelNode:SKLabelNode!
    
    // スコア用
    var score = 0
    var scoreLabelNode:SKLabelNode!
    var bestScoreLabelNode:SKLabelNode!
    var itemScore = 0
    var itemScoreLabelNode:SKLabelNode!
    var playerHeartLabelNode:SKLabelNode!
    let userDefaults:UserDefaults = UserDefaults.standard
    
    // ゲームオーバー表示
    var gameOverLabelNode:SKLabelNode!
    
    // スクリーンサイズ
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    var scale:CGFloat!    // 端末サイズ比
    
    var playerHP:Int32!
    var gameOver:Bool!
    
    // SKView上にシーンが表示されたときに呼ばれるメソッド
    override func didMove(to view: SKView) {
        
        // ゲーム開始
        print("Game Start")
        gameOver = false
        // 重力を設定（最終的に削除）
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // 画面サイズ取得
        screenWidth = self.frame.size.width // UIScreen.main.bounds.width
        screenHeight = self.frame.size.height // UIScreen.main.bounds.height
        // アスペクト比  横/縦
        scale = 1.0
        let imageAspect = 0.50
        let screenAspect = screenWidth / screenHeight
        if imageAspect < screenAspect { // 横長
            scale = scale * screenWidth / 330 // 背景画像横サイズ
        }else{ // 縦長
            scale = scale * screenHeight / 660 // 背景画像縦サイズ
        }
        
        // 背景色を設定
        //backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1) // 青
        //backgroundColor = UIColor(red: 0.80, green: 0.60, blue: 1.00, alpha: 1) // 紫
        //backgroundColor = UIColor(red: 0.20, green: 0, blue: 0.60, alpha: 1) // 濃い青
        //backgroundColor = UIColor(red: 0.63, green: 1, blue: 0, alpha: 1) // 黄緑
        backgroundColor = UIColor(red: 0.99, green: 0.72, blue: 0.43, alpha: 1) // オレンジ
        
        // スクロールするスプライトの親ノード
        scrollNode = SKNode()
        addChild(scrollNode)
        
        // 画面周りのノード
        flameNode = SKNode()
        scrollNode.addChild(flameNode)
        
        // 背景ノード
        backgroundNode = SKNode()
        scrollNode.addChild(backgroundNode)
        
        // ターゲットの親ノード
        targetNode = SKNode()
        scrollNode.addChild(targetNode)
        
        // スコアノード
        scoreNode = SKNode()
        scrollNode.addChild(scoreNode)
        
        // ボタンノード
        uiButtonNode = SKNode()
        addChild(uiButtonNode)
        
        // 各種スプライト生成
        setupFlame()       // 画面周りフレーム
        setupBackground()  // 背景
        setupTarget()      // ターゲット
        //setupItem()        // アイテム
        setupScore()       // スコア
        setupPlayer()      // プレイヤー
        //setupUIButton()    // ボタン

        
        setupScoreLabel()  // スコア
        setupGameOverLabel() // ゲームオーバー
    }
    
    func setupFlame(){
        // フレーム画像読み込み
        let flameTexture = SKTexture(imageNamed: "flame")
        flameTexture.filteringMode = .nearest
        // フレームノード作成
        let flame = SKNode()
        let upFlame = SKSpriteNode(texture: flameTexture) // 上フレーム
        upFlame.size = CGSize(width: upFlame.size.width*screenWidth/120, height: upFlame.size.height)
        upFlame.position = CGPoint(x: screenWidth/2, y:-upFlame.size.height/2)
        upFlame.physicsBody = SKPhysicsBody(rectangleOf: upFlame.size)
        upFlame.physicsBody?.categoryBitMask = flameCategory
        upFlame.physicsBody?.isDynamic = false
        flame.addChild(upFlame)
        let downFlame = SKSpriteNode(texture: flameTexture) // 下フレーム
        downFlame.size = CGSize(width: downFlame.size.width*screenWidth/120, height: downFlame.size.height)
        downFlame.position = CGPoint(x: screenWidth/2, y:screenHeight + downFlame.size.height/2)
        downFlame.physicsBody = SKPhysicsBody(rectangleOf: downFlame.size)
        downFlame.physicsBody?.categoryBitMask = flameCategory
        downFlame.physicsBody?.isDynamic = false
        flame.addChild(downFlame)
        let leftFlame = SKSpriteNode(texture: flameTexture) // 左フレーム
        leftFlame.size = CGSize(width: leftFlame.size.width, height: leftFlame.size.height*screenHeight/120)
        leftFlame.position = CGPoint(x: -leftFlame.size.width/2, y:screenHeight/2)
        leftFlame.physicsBody = SKPhysicsBody(rectangleOf: leftFlame.size)
        leftFlame.physicsBody?.categoryBitMask = flameCategory
        leftFlame.physicsBody?.isDynamic = false
        flame.addChild(leftFlame)
        let rightFlame = SKSpriteNode(texture: flameTexture) // 右フレーム
        rightFlame.size = CGSize(width: rightFlame.size.width, height: rightFlame.size.height*screenHeight/120)
        rightFlame.position = CGPoint(x: screenWidth + rightFlame.size.width/2, y:screenHeight/2)
        rightFlame.physicsBody = SKPhysicsBody(rectangleOf: rightFlame.size)
        rightFlame.physicsBody?.categoryBitMask = flameCategory
        rightFlame.physicsBody?.isDynamic = false
        flame.addChild(rightFlame)
        self.flameNode.addChild(flame)
        
    }

    func setupBackground(){
        // 画像読み込み
        let backgroundTexture = SKTexture(imageNamed: "シューティング_背景")
        backgroundTexture.filteringMode = .nearest
        // スプライト配置
        let sprite = SKSpriteNode(texture: backgroundTexture)
        // 位置指定
        sprite.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        sprite.zPosition = 10
        // サイズ指定
        sprite.size = CGSize(width: sprite.size.width*scale, height: sprite.size.height*scale)
        // スプライト追加
        backgroundNode.addChild(sprite)
    }
    
    func setupTarget(){
        // SKAction内で読み込めないためスクリーンサイズを転写
        let screenWidth2 = self.frame.size.width
        let screenHeight2 = self.frame.size.height
        // 画像読み込み
        let targetTexture = SKTexture(imageNamed: "target(40)")
        // 生成位置のx,y軸振れ幅
        let random_x_range: CGFloat = 0.8
        let random_y_range: CGFloat = 0.8
        // 生成位置の中央位置を取得
        let centerPoint = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.6)
        // 生成し自然消滅するまでの時間
        var approachingInterval:CGFloat = 3.5
        // 生成の間隔
        var generationInterval:CGFloat = 0.9 // >0.5s
        // z軸を移動する単位時間
        var zLineInterval:CGFloat = approachingInterval / 10
        // 1つのエレメントの物理演算が有効な時間 < 生成間隔
        var physicsValidInterval = 0.3
        // 生成アクション
        let createTargetAnimation = SKAction.run ({
            // xのランダム値
            let random_x = CGFloat.random(in: -random_x_range*screenWidth2/2/50...random_x_range*screenWidth2/2/50)
            // yのランダム値
            let random_y = CGFloat.random(in: -random_y_range*screenHeight2/2/50...random_y_range*screenHeight2/2/50)
            // ターゲットの位置を決定
            let targetPosition = CGPoint(x: centerPoint.x + random_x, y: centerPoint.y + random_y)
            // ターゲットを生成
            let targetElement = SKSpriteNode(texture: targetTexture)
            targetElement.position = targetPosition
            targetElement.zPosition = 20
            // 初期サイズ設定
            let targetScale = CGSize(width: 0.1, height: 0.1)
            targetElement.xScale = targetScale.width
            targetElement.yScale = targetScale.height
            
            // 拡大するアニメーション
            let scaleTarget = SKAction.scale(by: 30, duration: approachingInterval)
            // 移動する（x,y軸）アニメーション
            let moveTarget = SKAction.move(to: CGPoint(x: screenWidth2/2 + random_x*50,y: screenHeight2/2 + random_y*50), duration: approachingInterval)
            // 取り除くアクション
            let removeTarget = SKAction.removeFromParent()
            // 順に実行するアニメーション
            let targetAnimation = SKAction.sequence([moveTarget, removeTarget])
            targetElement.run(scaleTarget)
            targetElement.run(targetAnimation)
            
            // 物理演算を適用するまでの待ちアクション
            let waitPhysicsAnimation = SKAction.wait(forDuration: approachingInterval - physicsValidInterval)
            
            // 物理演算を適用するアニメーション
            let targetPhysicsBodyAnimation = SKAction.run ({
                targetElement.physicsBody = SKPhysicsBody(rectangleOf: targetTexture.size())
                targetElement.physicsBody?.categoryBitMask = self.targetCategory
                targetElement.physicsBody?.isDynamic = false
            })
            // 順に実行するアニメーション
            let PhysicsAnimation = SKAction.sequence([waitPhysicsAnimation, targetPhysicsBodyAnimation])
            targetElement.run(PhysicsAnimation)
            
            // z軸の接近を適用する待ちアクション
            let waitApproachingAnimation = SKAction.wait(forDuration: zLineInterval)
            // z軸の接近アニメーション(単位時間毎)
            let targetApproachingAnimation = SKAction.run ({
                targetElement.zPosition += 25 / (approachingInterval / zLineInterval)
                //targetElement.zPosition += 5
            })
            // 接近を繰り返すアクション
            let approachingAnimation = SKAction.repeatForever(SKAction.sequence([waitApproachingAnimation, targetApproachingAnimation]))
            targetElement.run(approachingAnimation)
            
            
            self.targetNode.addChild(targetElement)
            
        })
        
        // 次のターゲット生成までの待ち時間のアクションを作成
        let waitAnimation = SKAction.wait(forDuration: generationInterval)
        // ターゲット生成->待ちを無限に繰り返すアクション
        let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([createTargetAnimation, waitAnimation]))
        targetNode.run(repeatForeverAnimation)
        
    }
    
    func setupPlayer(){
        playerHP = 3
        // 画像読み込み
        let playerTexture = SKTexture(imageNamed: "player_blue")
        playerTexture.filteringMode = .linear
        // スプライト作成
        player = SKSpriteNode(texture: playerTexture)
        player.size = CGSize(width: player.size.width*scale, height: player.size.height*scale)
        player.position = CGPoint(x: screenWidth*0.5, y: screenHeight*0.4)
        player.zPosition = 90
        // 物理演算を設定
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2)
        // 衝突時に回転させない
        player.physicsBody?.allowsRotation = false
        
        // 衝突のカテゴリー設定
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = targetCategory
        player.physicsBody?.contactTestBitMask = targetCategory | itemCategory
        // スプライト追加
        addChild(player)
        /*
        // ハート画像読み込み
        let playerHeartTexture = SKTexture(imageNamed: "heart(40)")
        playerHeartTexture.filteringMode = .linear
        // スプライト作成
        playerHeart =
        */
    }
    
    // 画面タッチ時に呼び出し
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let touch = touches.first as UITouch?
        //let location = touch.locationInNode(self)
        if !gameOver {
            for touch in touches {
                let location = touch.location(in: view)
                player.run(SKAction.move(to: CGPoint(x:location.x, y:screenHeight - location.y), duration: 0.15))
                
            }
        } else if !gameOver && playerHP == 0 {
            return
        } else if let touch = touches.first as UITouch? {
            
            for elementNode in self.nodes(at: touch.location(in: self)) {
                if elementNode.name == "homeButton" {
                    print("ホームに戻る")
                    /*
                    let homeScene = HomeScene(size: self.size)
                    homeScene.scaleMode = SKSceneScaleMode.aspectFill
                    self.view!.presentScene(homeScene)
                    */
                    //self.inputViewController?.dismiss(animated: true, completion: nil)
                    // 現在のGameViewControllerにアクセス
                    let gameViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController!
                    //let homeViewController = ViewController()
                    //gameViewController?.present(homeViewController, animated: true, completion: nil)
                    //gameViewController?.homeButton.isHidden = false
                    gameViewController?.dismiss(animated: true, completion: nil)
                } else if elementNode.name == "retryButton" {
                    gameOver = false
                    restart()
                } else {
                    print("No operation")
                    return
                }
                
            }
            //let skView = self.scene as! SKScene
            //let location = touch.locationInNode(self)
            //let location = touch.location(in: view)
            //let touchedNode = self.nodes(at: location)
            //if self.nodeAtPoint(location).name == "button" {
            //if self.nodes(at: location).name == "button" {
            //if touchedNode.name == "button" {
                // Homeに戻る
                //performSegue(withIdentifier: "Home", sender: nil)
                
            //let homeScene = HomeScene(size: skView)
                //homeScene.scaleMode = SKSceneScaleMode.aspectFill
                //self.view!.presentScene(homeScene)
            //}
            
            
        } else {
            return
        }
        
    }
    // 移動時に呼び出し
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameOver {
            for touch in touches {
                let location = touch.location(in: view)
                // 位置の偏差
                let xdistance =  location.x - player.position.x
                let ydistance =  location.y - (screenHeight - player.position.y)
                
                player.run(SKAction.move(to: CGPoint(x:location.x, y:screenHeight - location.y), duration: 0.15))
                /*
                xImpulse = xdistance / screenWidth * 20
                yImpulse = -ydistance / screenHeight * 20
                // タップ位置とプレイヤーの位置が近い時に減速するようにする係数
                let damperGain = sqrt(pow(xdistance, 2) + pow(ydistance, 2)) / sqrt(pow(screenWidth, 2) + pow(screenHeight, 2))
                
                // 力を加える
                player.physicsBody?.applyImpulse(CGVector(dx: xImpulse, dy: yImpulse))
                player.physicsBody?.velocity.dx *= 2*sin(damperGain*M_PI)
                player.physicsBody?.velocity.dy *= 2*sin(damperGain*M_PI)
                print("damperGain=\(cos(damperGain*M_PI))")
                */
                 // 元の角度に戻す
                //player.run(SKAction.rotate(byAngle: 0, duration: 1))
            }
        }
    }
    
    
    // SKPhysicsContactDelegateのメソッド。衝突した時に呼ばれる
    func didBegin(_ contact: SKPhysicsContact){
        print("衝突しました")
        // ゲームオーバー時は何もしない
        if gameOver{
            return
        }
        if (contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory{
            contact.bodyA.node?.removeFromParent()
            // スコア用の物体と衝突
            scoreUp()
        } else if (contact.bodyB.categoryBitMask & scoreCategory) == scoreCategory {
            contact.bodyB.node?.removeFromParent()
            // スコア用の物体と衝突
            scoreUp()
        } else if  (contact.bodyA.categoryBitMask & targetCategory) == targetCategory{
            contact.bodyA.node?.removeFromParent()
            // ターゲットに衝突
            damageAction()
        } else if (contact.bodyB.categoryBitMask & targetCategory) == targetCategory{
            contact.bodyB.node?.removeFromParent()
            // ターゲットに衝突
            damageAction()
        } else {
            print("何も起こらなかった")
        }
    }
    func scoreUp(){
        print("ScoreUp")
        score += 1
        scoreLabelNode.text = "Score:\(score)"
        if let soundURL = Bundle.main.url(forResource: "リンゴをかじる", withExtension: "mp3") {
            do {
                itemPlayer = try AVAudioPlayer(contentsOf: soundURL)
                itemPlayer?.play()
            } catch {
                print("error")
            }
        }
        // ベストスコア更新か確認する
        var bestScore = userDefaults.integer(forKey: "BEST")
        if score > bestScore {
            bestScore = score
            bestScoreLabelNode.text = "Best:\(bestScore)"
            userDefaults.set(bestScore, forKey: "BEST")
            userDefaults.synchronize()
        }
    }
    func damageAction() {
        print("Damage")
        playerHP -= 1
        playerHeartLabelNode.text = ""
        for i in 0..<playerHP{
            playerHeartLabelNode.text?.append(contentsOf: "❤︎")
        }
        if playerHP <= 0{
            if let soundURL = Bundle.main.url(forResource: "爆発1", withExtension: "mp3") {
                do {
                    itemPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    itemPlayer?.play()
                } catch {
                    print("error")
                }
            }
            print("GameOver")
            self.gameOver = true
            gameOverLabelNode.text = "GAME OVER"
            targetNode.speed = 0
            scoreNode.speed = 0
            let roll = SKAction.rotate(byAngle: CGFloat(Double.pi)*CGFloat(player.position.y) * 0.01, duration: 1)
            player.run(roll)
            // 音声が流れ終わってから終了
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                self.setupUIButton()
                
            }
            
        }else{
            if let soundURL = Bundle.main.url(forResource: "小パンチ", withExtension: "mp3") {
                do {
                    itemPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    itemPlayer?.play()
                } catch {
                    print("error")
                }
            }
        }
    }
    
    func restart() {
        score = 0
        scoreLabelNode.text = "Score:\(score)"
        playerHP = 3
        playerHeartLabelNode.text = ""
        for i in 0..<playerHP{
            playerHeartLabelNode.text?.append(contentsOf: "❤︎")
        }
        //itemScore = 0
        //itemScoreLabelNode.text = "ItemScore:\(itemScore)"
        gameOverLabelNode.text = ""
        player.position = CGPoint(x: screenWidth*0.5, y: screenHeight*0.4)
        player.zPosition = 50
        player.physicsBody?.velocity = CGVector.zero
        player.physicsBody?.collisionBitMask = targetCategory
        player.zRotation = 0
        
        targetNode.removeAllChildren()
        targetNode.speed = 1
        scoreNode.removeAllChildren()
        scoreNode.speed = 1
        
        uiButtonNode.removeAllChildren()
        
    }
    
    func setupScoreLabel() {
        
        stage = 1
        stageLabelNode = SKLabelNode()
        stageLabelNode.fontColor = UIColor.black
        stageLabelNode.position = CGPoint(x: 10, y:self.frame.size.height - 80)
        stageLabelNode.zPosition = 100 // 一番手前にする
        stageLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        stageLabelNode.text = "Stage:\(stage)"
        self.addChild(stageLabelNode)
        
        score = 0
        scoreLabelNode = SKLabelNode()
        scoreLabelNode.fontColor = UIColor.black
        scoreLabelNode.position = CGPoint(x: screenWidth - 10, y:self.frame.size.height - 80)
        scoreLabelNode.zPosition = 100 // 一番手前にする
        scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        scoreLabelNode.text = "Score:\(score)"
        self.addChild(scoreLabelNode)
        
        bestScoreLabelNode = SKLabelNode()
        bestScoreLabelNode.fontColor = UIColor.black
        bestScoreLabelNode.position = CGPoint(x: screenWidth - 10, y: self.frame.size.height - 120)
        bestScoreLabelNode.zPosition = 100 // 一番手前に表示する
        bestScoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        let bestScore = userDefaults.integer(forKey: "BEST")
        bestScoreLabelNode.text = "Best:\(bestScore)"
        //self.addChild(bestScoreLabelNode)
        
        /*
        itemScoreLabelNode = SKLabelNode()
        itemScoreLabelNode.fontColor = UIColor.black
        itemScoreLabelNode.position = CGPoint(x: screenWidth - 10, y: self.frame.size.height - 150)
        itemScoreLabelNode.zPosition = 100 // 一番手前にする
        itemScoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        itemScoreLabelNode.text = "ItemScore:\(itemScore)"
        self.addChild(itemScoreLabelNode)
        */
        
        playerHeartLabelNode = SKLabelNode()
        playerHeartLabelNode.fontColor = UIColor.systemPink
        playerHeartLabelNode.position = CGPoint(x: screenWidth - 10, y: self.frame.size.height - 120)
        playerHeartLabelNode.zPosition = 100 // 一番手前にする
        playerHeartLabelNode.fontSize = 40
        playerHeartLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        playerHeartLabelNode.text = ""
        for i in 0..<playerHP{
            playerHeartLabelNode.text?.append(contentsOf: "❤︎")
        }
        self.addChild(playerHeartLabelNode)
    }
    func setupGameOverLabel(){
        gameOverLabelNode = SKLabelNode()
        gameOverLabelNode.fontColor = UIColor.systemYellow
        gameOverLabelNode.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        gameOverLabelNode.fontSize = 55
        gameOverLabelNode.zPosition = 100 // 一番手前にする
        gameOverLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        gameOverLabelNode.text = ""
        self.addChild(gameOverLabelNode)
    }
    
    func setupScore(){
        
        // SKAction内で読み込めないためスクリーンサイズを転写
        let screenWidth2 = self.frame.size.width
        let screenHeight2 = self.frame.size.height
        // 画像読み込み
        let targetTexture = SKTexture(imageNamed: "apple")
        // 生成位置のx,y軸振れ幅
        let random_x_range: CGFloat = 0.8
        let random_y_range: CGFloat = 0.8
        // 生成位置の中央位置を取得
        let centerPoint = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.6)
        // 生成し自然消滅するまでの時間
        var approachingInterval:CGFloat = 5.0
        // 生成の間隔
        var generationInterval:CGFloat = 1.25 // >0.5s
        // z軸を移動する単位時間
        var zLineInterval:CGFloat = approachingInterval / 10
        // 1つのエレメントの物理演算が有効な時間 < 生成間隔
        var physicsValidInterval = 0.3
        // 生成アクション
        let createTargetAnimation = SKAction.run ({
            // xのランダム値
            let random_x = CGFloat.random(in: -random_x_range*screenWidth2/2/50...random_x_range*screenWidth2/2/50)
            // yのランダム値
            let random_y = CGFloat.random(in: -random_y_range*screenHeight2/2/50...random_y_range*screenHeight2/2/50)
            // ターゲットの位置を決定
            let targetPosition = CGPoint(x: centerPoint.x + random_x, y: centerPoint.y + random_y)
            // ターゲットを生成
            let targetElement = SKSpriteNode(texture: targetTexture)
            targetElement.position = targetPosition
            targetElement.zPosition = 20
            // 初期サイズ設定
            let targetScale = CGSize(width: 0.1, height: 0.1)
            targetElement.xScale = targetScale.width
            targetElement.yScale = targetScale.height
            
            // 拡大するアニメーション
            let scaleTarget = SKAction.scale(by: 30, duration: approachingInterval)
            // 移動する（x,y軸）アニメーション
            let moveTarget = SKAction.move(to: CGPoint(x: screenWidth2/2 + random_x*50,y: screenHeight2/2 + random_y*50), duration: approachingInterval)
            // 取り除くアクション
            let removeTarget = SKAction.removeFromParent()
            // 順に実行するアニメーション
            let targetAnimation = SKAction.sequence([moveTarget, removeTarget])
            targetElement.run(scaleTarget)
            targetElement.run(targetAnimation)
            
            // 物理演算を適用するまでの待ちアクション
            let waitPhysicsAnimation = SKAction.wait(forDuration: approachingInterval - physicsValidInterval)
            
            // 物理演算を適用するアニメーション
            let targetPhysicsBodyAnimation = SKAction.run ({
                targetElement.physicsBody = SKPhysicsBody(rectangleOf: targetTexture.size())
                targetElement.physicsBody?.categoryBitMask = self.scoreCategory
                targetElement.physicsBody?.contactTestBitMask = self.playerCategory
                targetElement.physicsBody?.isDynamic = false
            })
            // 順に実行するアニメーション
            let PhysicsAnimation = SKAction.sequence([waitPhysicsAnimation, targetPhysicsBodyAnimation])
            targetElement.run(PhysicsAnimation)
            
            // z軸の接近を適用する待ちアクション
            let waitApproachingAnimation = SKAction.wait(forDuration: zLineInterval)
            // z軸の接近アニメーション(単位時間毎)
            let targetApproachingAnimation = SKAction.run ({
                targetElement.zPosition += 25 / (approachingInterval / zLineInterval)
                //targetElement.zPosition += 5
            })
            // 接近を繰り返すアクション
            let approachingAnimation = SKAction.repeatForever(SKAction.sequence([waitApproachingAnimation, targetApproachingAnimation]))
            targetElement.run(approachingAnimation)
            
            
            self.scoreNode.addChild(targetElement)
            
        })
        
        // 次のターゲット生成までの待ち時間のアクションを作成
        let waitAnimation = SKAction.wait(forDuration: generationInterval / 2)
        // ターゲット生成->待ちを無限に繰り返すアクション
        let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([waitAnimation, createTargetAnimation, waitAnimation]))
        scoreNode.run(repeatForeverAnimation)
        
    }
    
    func setupUIButton(){
        // 画像読み込み
        let buttonTexture = SKTexture(imageNamed: "backWhite")
        buttonTexture.filteringMode = .nearest
        // スプライト配置
        let homeButton = SKSpriteNode(texture: buttonTexture)
        homeButton.name = "homeButton"
        // 位置指定
        homeButton.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.3)
        homeButton.zPosition = 100
        // サイズ指定
        homeButton.size = CGSize(width: homeButton.size.width*scale, height: homeButton.size.height*scale*0.3)
        // ラベル作成
        uiButtonBackLabel = SKLabelNode()
        uiButtonBackLabel.fontColor = UIColor.black
        uiButtonBackLabel.position = CGPoint(x: 0, y: -10)
        uiButtonBackLabel.fontSize = 30
        uiButtonBackLabel.zPosition = 100 // 一番手前にする
        uiButtonBackLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        uiButtonBackLabel.text = "Home"
        uiButtonBackLabel.name = "homeButton"
        homeButton.addChild(uiButtonBackLabel)
        uiButtonNode.addChild(homeButton)

        //print("homeButton.name = \(homeButton.name)")
        
        // スプライト配置
        let retryButton = SKSpriteNode(texture: buttonTexture)
        retryButton.name = "retryButton"
        // 位置指定
        retryButton.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.4)
        retryButton.zPosition = 100
        // サイズ指定
        retryButton.size = CGSize(width: retryButton.size.width*scale, height: retryButton.size.height*scale*0.3)
        // ラベル作成
        uiButtonBackLabel = SKLabelNode()
        uiButtonBackLabel.fontColor = UIColor.black
        uiButtonBackLabel.position = CGPoint(x: 0, y: -10)
        uiButtonBackLabel.fontSize = 30
        uiButtonBackLabel.zPosition = 100 // 一番手前にする
        uiButtonBackLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        uiButtonBackLabel.text = "Retry"
        uiButtonBackLabel.name = "retryButton"
        retryButton.addChild(uiButtonBackLabel)
        uiButtonNode.addChild(retryButton)
        
        
        
        
    }
}
