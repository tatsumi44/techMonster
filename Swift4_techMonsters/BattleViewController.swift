//
//  BattleViewController.swift
//  Swift4_techMonsters
//
//  Created by tatsumi kentaro on 2018/02/04.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel:UILabel!
    @IBOutlet var playerHPLabel:UILabel!
    @IBOutlet var playerImage:UIImageView!
    @IBOutlet var playerMPLabel:UILabel!
    @IBOutlet var playerTPLabel:UILabel!
    
    
    @IBOutlet var enemyNameLabel:UILabel!
    @IBOutlet var enemyHPLabel:UILabel!
    @IBOutlet var enemyImage:UIImageView!
    @IBOutlet var enemyMPLabel:UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var player: Character!
    var enemy: Character!

    var playerHP = 100
    var PlayerMP = 0
    var enemyHP = 200
    var enemyMP = 0
    
    var gettimer = Timer()
    var isplayerAttackAvailable:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        player = techMonManager.player
        enemy = techMonManager.enemy

        playerNameLabel.text = "勇者"
        playerImage.image = UIImage(named:"yusya.png")
//        playerHPLabel.text = "\(playerHP)/100"
//        playerMPLabel.text = "\(playerHP)/20"
        updateUI()
        
        enemyNameLabel.text = "龍"
        enemyImage.image = UIImage(named:"monster.png")
//        enemyHPLabel.text = "\(enemyHP)/200"
//        enemyMPLabel.text = "\(enemyMP)/35"
        
        gettimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateGame), userInfo: nil, repeats: true)
        
        gettimer.fire()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        techMonManager.stopBGM()
    }
    
    func updateUI()  {
        playerHPLabel.text = "\(player.currentHP)/\(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP)/\(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP)/\(player.maxTP)"
        enemyHPLabel.text = "\(enemy.currentHP)/\(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP)/\(enemy.maxMP)"
    }
    
    @objc func updateGame() {
        PlayerMP += 1
        if PlayerMP>20{
            isplayerAttackAvailable = true
            PlayerMP = 20
        }else{
            isplayerAttackAvailable = false
        }
        
        enemyMP += 1
        if enemyMP>=35 {
            enemyAttack()
            enemyMP = 0
        }
        enemyMPLabel.text = "\(enemyMP)/35"
        playerHPLabel.text = "\(PlayerMP)/20"
    }
    
    func enemyAttack() {
        techMonManager.damageAnimation(imageView: playerImage)
        techMonManager.playSE(fileName: "SE_attack")
        playerHP -= 20
        playerHPLabel.text = "\(playerHP)/100"
        if playerHP<=20{
            finishBattle(vanishImageView:playerImage,isPlayerWin:false)
        }
        
        player.currentTP += 10
        if player.currentTP >= player.maxTP{
            player.currentTP = player.maxTP
        }
        
    }
    
    func finishBattle(vanishImageView:UIImageView,isPlayerWin:Bool) {
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gettimer.invalidate()
        isplayerAttackAvailable = false
        
        var finishMessage: String = ""
        
        if isPlayerWin {
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利"
        }else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北"
        }
        
        let alert: UIAlertController = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:"OK",style:.default,handler:{ _ in
            self.dismiss(animated: true, completion: nil)
            
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func attack(){
        if isplayerAttackAvailable{
            techMonManager.damageAnimation(imageView: enemyImage)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemyHP -= 30
            PlayerMP = 0
//            updateUI()
            enemyHPLabel.text = "\(enemyHP)/200"
            playerMPLabel.text = "\(PlayerMP)/20"
            
            if enemyHP<=20{
                finishBattle(vanishImageView: enemyImage, isPlayerWin: true)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func judgeButtle(){
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImage, isPlayerWin: false)
        }else if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyImage, isPlayerWin: true)
        }
    }
    
    @IBAction func tameruAction(){
        if isplayerAttackAvailable{
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentTP >= player.maxTP{
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            
        }
    }
    
    @IBAction func fireAction(){
        
        if isplayerAttackAvailable && player.currentTP >= 40{
            techMonManager.damageAnimation(imageView: enemyImage)
            techMonManager.playSE(fileName: "SE_fire")
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
            }
            player.currentMP = 0
            judgeButtle()
            
            
        }
        
    }
    
    
}
