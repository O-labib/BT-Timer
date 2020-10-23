//
//  BTtimer.swift
//
//  Created by Omar on 3/12/20.
//  Copyright © 2020 Omar. All rights reserved.
//

import UIKit

public protocol BTtimerDelegate {
    func didStart()
    func didTimeOut()
    func didTick(with secondsLeft : Int)
    func didTimeOutWhileInBackground(since secondsPassed : Int)
}

public extension BTtimerDelegate {
    func didStart() {}
    func didTimeOut() {}
    func didTimeOutWhileInBackground(since secondsPassed : Int) {}
    func didTick(with secondsLeft : Int){}
}

public class BTtimer: NSObject {
    
    enum AppState {
        case foreground
        case background
    }
    
    //MARK: Variables
    private var timer : Timer?
    private let notificationCenter = NotificationCenter.default
    
    private weak var timerLabel : UILabel!
    
    private var timeRemainingInSecs : Int = 0
    private var initialTimeInSecs:Int!
    private lazy var timeRemainingWhenAppBecameInactive = currentTimeInSeconds()
    private var currentAppState : AppState = .background
    private var animate: Bool
    
    public var delegate : BTtimerDelegate?
    
    
    public var remainingTimeInSeconds:Int {
        get {
            return timeRemainingInSecs
        }
    }
    
    //MARK: Init
    public init(for timerLabel : UILabel, withTimeInSecs timeInSeconds : Int, animate: Bool) {
        self.timerLabel = timerLabel
        self.initialTimeInSecs = timeInSeconds
        self.animate = animate
        timeRemainingInSecs = initialTimeInSecs
        timerLabel.text = timeInSeconds.toPrettyTimeRemaining()
        super.init()
        
    }
    
    
    //MARK: Public Functions
    public func fire(){
        if timer?.isValid == true {
            return
        }
        fireTimer()
        unRegisterFocusObservers()
        registerFocusObservers()
    }
    
    private func registerFocusObservers(){
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedBackToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    
    
    public func reset(){
        resetTimerLabel()
        pause()
    }
    
    private func resetTimerLabel() {
        timeRemainingInSecs = initialTimeInSecs
        timerLabel.text = timeRemainingInSecs.toPrettyTimeRemaining()
    }
    
    public func pause() {
        if timer?.isValid == false {
            return
        }
        timer?.invalidate()
        timerLabel.layer.removeAllAnimations()
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
            self.timerLabel.alpha = 1
            self.timerLabel.transform = .identity
        })
    }
    
    public func resume() {
        fireTimer()
    }
    public func restart() {
        timeRemainingInSecs = 0
        reset()
        fire()
    }
    
    
    private func fireTimer(){
        timerLabel.text = timeRemainingInSecs.toPrettyTimeRemaining()
        
        restartTimer()
        
        delegate?.didStart()
        
        animateTimerLabel()
        
    }
    private func restartTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self , selector: (#selector(updateCounter)), userInfo: nil, repeats: true )
    }
    
    private func animateTimerLabel(){
        if animate {
            UIView.animate(withDuration: 0, delay: 0, animations: {
                self.timerLabel.alpha = 1
                self.timerLabel.transform = .identity
            }, completion: { _ in
                UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
                    self.timerLabel.alpha = 0.5
                    self.timerLabel.transform = CGAffineTransform(scaleX: 1.3, y:  1.3)
                })
            })
        }
    }
    
    
    @objc private func updateCounter(){
        let didTimeOut = timeRemainingInSecs <= 0
        if didTimeOut {
            
            delegate?.didTimeOut()
            
            stopTimerAnimationAndZeroLabel()
            
        } else {
            timerLabel.text = timeRemainingInSecs.toPrettyTimeRemaining()
            delegate?.didTick(with: timeRemainingInSecs)
            timeRemainingInSecs -= 1
        }
    }
    
    private func stopTimerAnimationAndZeroLabel() {
        self.timer?.invalidate()
        timerLabel.text = 0.toPrettyTimeRemaining()
        
        if !animate {
            return
        }
        
        if Double(initialTimeInSecs).isOddNumber() {
            self.timerLabel.layer.removeAllAnimations()
            self.timerLabel.alpha = 1
            self.timerLabel.transform = .identity
        }else {
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [], animations: {
                self.timerLabel.alpha = 1
                self.timerLabel.transform = .identity
            })
        }
    }
    
    @objc func appMovedToBackground() {
        currentAppState = .background
        timer?.invalidate()
        timeRemainingWhenAppBecameInactive = currentTimeInSeconds()
    }
    
    @objc func appMovedBackToForeground() {
        if currentAppState == .foreground {
            return
        }
        currentAppState = .foreground
        accountForTimePassedWhileInBackground()
        let timedOutInBackground = timeRemainingInSecs <= 0
        if timedOutInBackground {
            stopTimerIfTimedOutWhileInBackground()
        } else {
            resumeTimerAfterReturningToForeground()
        }
    }
    
    private func accountForTimePassedWhileInBackground(){
        timeRemainingInSecs -= Int(currentTimeInSeconds() - timeRemainingWhenAppBecameInactive)
        // safety factor
        // timeRemainingInSecs += 2
    }
    
    
    private func stopTimerIfTimedOutWhileInBackground(){
        self.timerLabel.alpha = 1
        self.timerLabel.transform = .identity
        self.timerLabel.layer.removeAllAnimations()
        
        timerLabel.text = 0.toPrettyTimeRemaining()
        self.timer?.invalidate()
        delegate?.didTimeOutWhileInBackground(since: -(timeRemainingInSecs))
    }
    func resumeTimerAfterReturningToForeground(){
        fireTimer()
    }
    
    deinit {
        unRegisterFocusObservers()
    }
    
    private func unRegisterFocusObservers(){
        notificationCenter.removeObserver(UIApplication.didEnterBackgroundNotification)
        notificationCenter.removeObserver(UIApplication.willEnterForegroundNotification)
    }
}


private extension BTtimer {
    private func currentTimeInSeconds() -> Int64 {
        return Int64((Date().timeIntervalSince1970).rounded())
    }
}

private extension Int {
    func toPrettyTimeRemaining() -> String {
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


private extension Double {
    func isOddNumber() -> Bool {
        return !(self.remainder(dividingBy: 2) == 0)
    }
}
