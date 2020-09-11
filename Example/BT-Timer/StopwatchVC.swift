//
//  TimerViewController.swift
//  BT-Timer_Example
//
//  Created by mac on 9/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import BT_Timer
class StopwatchVC: UIViewController {

    
    @IBOutlet weak var animatableTimerLabel: UILabel!
    @IBOutlet weak var staticTimerLabel: UILabel!
    
    var animatableStopwatch:BTstopwatch!
    var staticStopwatch:BTstopwatch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animatableStopwatch = BTstopwatch.init(for: animatableTimerLabel, animated: true)
        staticStopwatch = BTstopwatch.init(for: staticTimerLabel, animated: false)
    }
    

    @IBAction func startAction(_ sender: Any) {
        animatableStopwatch.fire()
        staticStopwatch.fire()
    }
    @IBAction func pauseAction(_ sender: Any) {
        animatableStopwatch.pause()
        staticStopwatch.pause()
    }
    @IBAction func resetAction(_ sender: Any) {
        animatableStopwatch.stop()
        staticStopwatch.stop()
    }
    @IBAction func restartAction(_ sender: Any) {
        animatableStopwatch.restart()
        staticStopwatch.restart()
    }

}
