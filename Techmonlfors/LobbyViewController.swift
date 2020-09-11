//
//  LobbyViewController.swift
//  Techmonlfors
//
//  Created by 森田貴帆 on 2020/09/07.
//  Copyright © 2020 森田貴帆. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    @IBOutlet var namelabel:UILabel!
    @IBOutlet var staminalabel:UILabel!
    
    let techMonManager = TechMonManager.shared
    var stamina: Int = 100
    var staminaTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        namelabel.text = "勇者"
        staminalabel.text = "\(stamina)/100"
        staminaTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateStaminaValue), userInfo: nil, repeats: true)
        staminaTimer.fire()
    }
    
    //ロビーが見えるようになったときに呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
    
    //ロビー画面が見えなくなる時に呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    @IBAction func gobattle(){
        //スタミナが50以上なら消費して次の画面へ
        if stamina >= 50{
            stamina -= 50
            staminalabel.text =  "\(stamina)/100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else{
            let alert = UIAlertController(
                title: "バトルに行けません",
                message: "スタミナを貯めてください",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            }
        }
    @objc func updateStaminaValue(){
        if stamina < 100{
            stamina += 1
            staminalabel.text = "\(stamina)/100"
        }
        
    }

}
