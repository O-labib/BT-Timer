//
//  CountDownHelper.swift
//  CountDownHelper
//
//  Created by Omar on 3/12/20.
//  Copyright © 2020 Omar. All rights reserved.
//

import UIKit
public protocol StopwatchDelegate {
    func stopwatchWasInterrupted(at timePassedInSec:Int)
}

public class BTstopwatch: NSObject {
    
    enum AppState {
        case foreground
        case background
    }
    
    private let notificationCenter = NotificationCenter.default
    private var timer : Timer?

    private let stopwatchLabel : UILabel!
    private var timePassedWhenAppBecameInactive : Int?

    private var currentAppState : AppState = .background
    private var secondsPassed : Int = 0
    private var animated: Bool

    public var delegate : StopwatchDelegate?
    
    public var timePassedInSeconds:Int {
        get {
            return secondsPassed
        }
    }
    
    public init(for stopwatchLabel : UILabel, animated: Bool) {
        self.stopwatchLabel = stopwatchLabel
        self.animated = animated
        super.init()
        stopwatchLabel.text = 0.toPrettyTimePassed()

    }
    
    
    public func fire(){
        if timer?.isValid == true {
            return
        }
        unRegisterFocusObservers()
        registerFocusObservers()
        fireTimer()
    }
    
    private func registerFocusObservers(){
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedBackToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    private func unRegisterFocusObservers(){
        notificationCenter.removeObserver(UIApplication.didEnterBackgroundNotification)
        notificationCenter.removeObserver(UIApplication.willEnterForegroundNotification)
    }
    
    private func fireTimer(){
        stopwatchLabel.text = secondsPassed.toPrettyTimePassed()

        restartTimer()
        
        animateStopwatchLabel()
    }
    
    private func restartTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self , selector: (#selector(updateCounter)), userInfo: nil, repeats: true )
    }
    
    @objc private func updateCounter(){
        stopwatchLabel.text = secondsPassed.toPrettyTimePassed()
        secondsPassed += 1
    }
    
    private func animateStopwatchLabel() {
        if animated{
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.stopwatchLabel.alpha = 1
                self.stopwatchLabel.transform = .identity
            }, completion: { _ in
                
                UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
                    self.stopwatchLabel.alpha = 0.5
                    self.stopwatchLabel.transform = CGAffineTransform(scaleX: 1.3, y:  1.3)
                }, completion: nil)
            })
        }
    }
    
    
    public func pause(){
        cancelTimer()
    }
    
    public func stop() {
        cancelTimer()
        zeroTimer()
    }
    
    public func restart() {
        stop()
        fire()
    }
    public func resume() {
        fire()
    }
    
    private func cancelTimer(){
        if timer?.isValid == false {
            return
        }
        self.timer?.invalidate()
        animateLabelToOriginalState()
    }
    private func animateLabelToOriginalState() {
        if animated{
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.stopwatchLabel.alpha = 1
                self.stopwatchLabel.transform = .identity
            }, completion: nil)
        }
    }
    func zeroTimer(){
        secondsPassed = 0
        stopwatchLabel.text = 0.toPrettyTimePassed()
    }

    @objc func appMovedToBackground() {
        currentAppState = .background
        timer?.invalidate()
        timePassedWhenAppBecameInactive = Int(currentTimeInSeconds())
        delegate?.stopwatchWasInterrupted(at: secondsPassed)
    }
    
    @objc func appMovedBackToForeground() {
        if currentAppState == .foreground {
            return
        }
        currentAppState = .foreground
        guard let _ = timePassedWhenAppBecameInactive else { return }
        secondsPassed += Int(currentTimeInSeconds()) - timePassedWhenAppBecameInactive!
        // safety factor
     //   timePassedInSeconds += 2
        fire()
    }
    
    
}

private extension BTstopwatch {
    private func currentTimeInSeconds() -> Int64 {
        return Int64((Date().timeIntervalSince1970).rounded())
    }
}

private extension Int {
    func toPrettyTimePassed() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        let minutesAndSeconds = String(format:"\(minutes > 9 ? "\(minutes)" : "0\(minutes)") : \(seconds > 9 ? "\(seconds)" : "0\(seconds)")")
        var timeToDisplay = minutesAndSeconds
        if hours > 0 {
            timeToDisplay = "\(hours) : " + minutesAndSeconds
        }
        return timeToDisplay
    }
}
