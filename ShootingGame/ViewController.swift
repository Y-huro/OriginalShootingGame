//
//  ViewController.swift
//  ShootingGame
//
//  Created by y i on 2022/02/13.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    let userDefaults:UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBAction func gameStartButton(_ sender: Any) {
        //performSegue(withIdentifier: "Game", sender: nil)
        //let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "Game") as! GameViewController
        //self.present(gameViewController, animated: true, completion: nil)
    }
    @IBOutlet weak var gameStartButtonOutlet: UIButton!
    
    @IBAction func rankingButton(_ sender: Any) {
        //performSegue(withIdentifier: "Ranking", sender: nil)
        //let rankingViewController = self.storyboard?.instantiateViewController(withIdentifier: "Ranking") as! RankingViewController
        //self.present(rankingViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var rankingButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SKViewに型を変換する
        let skView = self.view as! SKView

        // FPSを表示する
        skView.showsFPS = true

        // ノードの数を表示する
        skView.showsNodeCount = true

        // ビューと同じサイズでシーンを作成する
        let homeScene = HomeScene(size: skView.frame.size)
        //let gameScene = GameScene(size: skView.frame.size)
        
        // ビューにシーンを表示する
        skView.presentScene(homeScene)
        //skView.presentScene(gameScene)
        
        // タイトル
        //titleLabel.font = titleLabel.font.withSize(30)
        
        // スコア
        var bestScore = userDefaults.integer(forKey: "BEST")
        if bestScore > 0 {
            recordLabel.text = "Best  \(bestScore)"
        }else{
            recordLabel.text = ""
        }
        //recordLabel.font = recordLabel.font.withSize(20)
        
        // ゲーム開始
        //gameStartButtonOutlet.titleLabel?.font = gameStartButtonOutlet.titleLabel?.font.withSize(25)
        
        // ランキング
        //rankingButtonOutlet.titleLabel?.font = rankingButtonOutlet.titleLabel?.font.withSize(25)
        rankingButtonOutlet.isHidden = true
        
    }
    
    // ステータスバーを消す
    /*override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }*/
    
    


}

