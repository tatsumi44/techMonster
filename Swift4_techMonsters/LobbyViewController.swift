//
//  LobbyViewController.swift
//  Swift4_techMonsters
//
//  Created by tatsumi kentaro on 2018/02/04.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel: UILabel!
    
    let techManeger = TechMonManager.shared
    
    var stamina: Int = 100
    var staminaTimer:Timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "勇者"
        staminaLabel.text = "\(stamina)/100"
        staminaTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.updatestaminaValue), userInfo: nil, repeats: true)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techManeger.playBGM(fileName:"lobby")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techManeger.stopBGM()
    }
    
    @IBAction func toBattle(){
        if stamina>=50{
            stamina -= 50
            staminaLabel.text = "\(stamina)/100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else{
            let alert:UIAlertController = UIAlertController(title: "バトルに行けません", message: "スタミナが足りません", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(
                title:"OK",
                style:.default,
                handler: { action in
                    //ボタンが押された時の動作
                    print("OKボタンが押されました!")
            }))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updatestaminaValue(){
        if stamina < 100 {
            stamina += 1
            staminaLabel.text = "\(stamina)/100"
        }
    }
    

   

}
