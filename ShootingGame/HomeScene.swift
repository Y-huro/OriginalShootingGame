//
//  HomeScene.swift
//  ShootingGame
//
//  Created by y i on 2022/02/20.
//

import UIKit
//import Foundation
import SpriteKit
import AVFoundation

class HomeScene: SKScene {
    
    var GameNode:SKNode!
    var RankingNode:SKNode!
    
    
    // SKView上にシーンが表示されたときに呼ばれるメソッド
    override func didMove(to view: SKView) {
    
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) // 白
        //backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1) // 青
        //backgroundColor = UIColor(red: 0.99, green: 0.72, blue: 0.43, alpha: 1) // オレンジ
        
        //GameNode = SKNode()
        //RankingNode = SKNode()
        
        setupGame()
        setupRanking()
    
    }
    
    
    func setupGame(){
        
    }
    
    func setupRanking(){
        
    }
    
}
