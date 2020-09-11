//
//  ViewController.swift
//  BT_Timer
//
//  Created by o.labib1995@gmail.com on 09/11/2020.
//  Copyright (c) 2020 o.labib1995@gmail.com. All rights reserved.
//

import UIKit
import BT_Timer

class TimerVC: UIViewController {
    
    @IBOutlet weak var animatableTimerLabel: UILabel!
    @IBOutlet weak var staticTimerLabel: UILabel!
    var animatableTimer:BTtimer!
    var staticTimer:BTtimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatableTimer = BTtimer(for: animatableTimerLabel, withTimeInSecs: 1 * 60 * 60, animate: true)
        staticTimer = BTtimer(for: staticTimerLabel, withTimeInSecs: 1 * 60 * 60, animate: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startAction(_ sender: Any) {
        animatableTimer.fire()
        staticTimer.fire()
    }
    @IBAction func pauseAction(_ sender: Any) {
        animatableTimer.pause()
        staticTimer.pause()
    }
    @IBAction func resetAction(_ sender: Any) {
        animatableTimer.reset()
        staticTimer.reset()
    }
    @IBAction func restartAction(_ sender: Any) {
        animatableTimer.restart()
        staticTimer.restart()
    }
}

