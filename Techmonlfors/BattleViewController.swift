//
//  BattleViewController.swift
//  Techmonlfors
//
//  Created by 森田貴帆 on 2020/09/07.
//  Copyright © 2020 森田貴帆. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    @IBOutlet var playernamelabel: UILabel!
    @IBOutlet var playerimageview: UIImageView!
    @IBOutlet var playerHPlabel: UILabel!
    @IBOutlet var playerMPlabel: UILabel!
    @IBOutlet var playerTPlabel: UILabel!
    
    @IBOutlet var enemynamelabel: UILabel!
    @IBOutlet var enemyimageview: UIImageView!
    @IBOutlet var enemyHPlabel: UILabel!
    @IBOutlet var enemyMPlabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    var player: Character!
    var enemy: Character!
    
    //var playerHP = 100
    //var playerMP = 0
    //var enemyHP = 200
    //var enemyMP = 0

    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        playernamelabel.text = "勇者"
        playerimageview.image = UIImage(named: "yusya.png")
       // playerHPlabel.text = "\(player.currentHP) / 100"
        //playerMPlabel.text = "\(player.currentMP) / 20"
        enemynamelabel.text = "龍"
        enemyimageview.image = UIImage(named: "monster.png")
        //enemyHPlabel.text = "\(enemy.currentHP) / 200"
        //enemyMPlabel.text = "\(enemy.currentMP) / 35"
        
        updateUI()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
        techMonManager.resetStatus()
    }
    
    @objc func updateGame(){
        //プレイヤーのステータスの更新
        player.currentMP += 1
        if player.currentMP >= 20{ //MPが20を超えたら攻撃できるようにする
            isPlayerAttackAvailable = true
            player.currentMP = 20
        }else{
            isPlayerAttackAvailable = false
        }
        //敵のステータスの更新
        enemy.currentMP += 1
        if enemy.currentMP >= 35{  //敵はMPが35までいったら自動的に一回攻撃する
            enemyAttack()
            enemy.currentMP = 0
        }
        playerMPlabel.text = "\(player.currentMP) /  \(player.maxHP)"
        enemyMPlabel.text = "\(enemy.currentMP) /  \(enemy.maxMP)"
    }
    
    func enemyAttack(){
        techMonManager.damageAnimation(imageView: playerimageview)
        techMonManager.playSE(fileName: "SE_attack")
        player.currentHP -= 20
        playerHPlabel.text = "\(player.currentHP) /  \(player.maxHP)"
       judgeBattle()
        //if player.currentHP <= 0{
        //    finishBattle(vanishImageView: playerimageview, isPlayerWin: false)
    }
 
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool){
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin{
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        } else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北"
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func attackAction(){
        if isPlayerAttackAvailable{
            techMonManager.damageAnimation(imageView: enemyimageview)
            techMonManager.playSE(fileName: "SE_attack")
            enemy.currentHP -= player.attackPoint
            player.currentTP += 10
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            
            updateUI()
            //enemyHPlabel.text = "\(enemyHP) / 200"
            //playerMPlabel.text = "\(playerMP) / 20"
            
            judgeBattle()
        }
    }
    
    @IBAction func fireAction(){
        if isPlayerAttackAvailable && player.currentTP >= 40{
            techMonManager.damageAnimation(imageView: enemyimageview)
            techMonManager.playSE(fileName: "SE_fire")
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
            }
            player.currentMP = 0
            judgeBattle()
            }
    }
    
    @IBAction func tameruAction(){
        if isPlayerAttackAvailable{
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            judgeBattle()
        }
    }
    //ステータスの反映
    func updateUI(){
        playerHPlabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPlabel.text = "\(player.currentMP) / \(player.maxMP)"
        playerTPlabel.text = "\(player.currentTP) / \(player.maxTP)"
        enemyHPlabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPlabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
    }
    
    //勝敗判定
    func judgeBattle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerimageview, isPlayerWin: false)
        }else if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyimageview, isPlayerWin: true)
        }
    }

}
