//
//  WindowUtil.swift
//  BugReporterTest
//
//  Created by Giridhar on 21/06/17.
//  Copyright © 2017 Giridhar. All rights reserved.
//

import Foundation
import UIKit

protocol Overlayable
{
    func show()
    func hide()
}

protocol WindowUtil: Overlayable {
    func show();
    func hide();
    var onStopClick:(() -> ())? { get set }
    var stopButtonColor: UIColor { get set }
}

class TopWindowUtil: WindowUtil {
    var overlayWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
    
    var backgroundView = UIView()
    
    var stopButton = UIButton(type: UIButton.ButtonType.custom)
    
    var _stopButtonColor: UIColor = UIColor(red:0.30, green:0.67, blue:0.99, alpha:1.00)
    var stopButtonColor: UIColor {
        get {
            return self._stopButtonColor
        }
        set {
            self._stopButtonColor = newValue
        }
    }
    
    var _onstopClick:(() -> ())?
    var onStopClick: (() -> ())? {
        get {
            return self._onstopClick
        }
        set {
            self._onstopClick = newValue
        }
    }
        
    init () {
        self.setupViews()
    }
    
    func setupViews () {
        initViews()
        
        backgroundView.frame = overlayWindow.frame
        backgroundView.backgroundColor = stopButtonColor
        overlayWindow.addSubview(backgroundView)
        
        stopButton.setTitle("Recording in Progress", for: .normal)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        
        stopButton.addTarget(self, action: #selector(stopRecording), for: UIControl.Event.touchDown)
        
        var y: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first
            y = (window?.safeAreaInsets.top ?? 0)
        }
        
        stopButton.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 30)
        backgroundView.addSubview(stopButton)
        
        overlayWindow.windowLevel = UIWindow.Level(CGFloat.greatestFiniteMagnitude)
        
    }
    
    func initViews() {
        var y: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first
            y = (window?.safeAreaInsets.top ?? 0)
        }
        overlayWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: y + 30))
        stopButton = UIButton(type: UIButton.ButtonType.custom)
        backgroundView = UIView()
    }
    
    func hide() {
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.3, animations: {
               self.backgroundView.transform = CGAffineTransform(translationX:0, y: -30)
            }, completion: { (animated) in
                self.overlayWindow.backgroundColor = .clear
                self.overlayWindow.isHidden = true
                self.backgroundView.isHidden = true
                self.backgroundView.transform = CGAffineTransform.identity;
            })
            
        }
        
    }
    
    @objc func stopRecording() {
        onStopClick?()
    }
    
    func show() {
        DispatchQueue.main.async {
            self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -30)
            self.backgroundView.backgroundColor = self.stopButtonColor
            self.overlayWindow.isHidden = false
            self.backgroundView.isHidden = false
            self.overlayWindow.makeKeyAndVisible()
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.transform = CGAffineTransform.identity
            }, completion: { (animated) in

            })
        }
        
    }
}

class FullWindowUtil: WindowUtil {
    var overlayWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var backgroundView = UIView()
    
    var progressBar = UIProgressView()
    
    
    var _stopButtonColor: UIColor = UIColor(red:0.30, green:0.67, blue:0.99, alpha:1.00)
    var stopButtonColor: UIColor {
        get {
            return self._stopButtonColor
        }
        set {
            self._stopButtonColor = newValue
        }
    }
    
    var onStopClick: (() -> ())? {
        get {
            return {}
        }
        set { }
    }
    
    var time: Float = 0
    var timeSpent: Float = 0
        
    init (time: Int) {
        self.time = Float(time)
        self.setupViews()
    }
    
    func initViews() {
        overlayWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        backgroundView = UIView()
        progressBar = UIProgressView()
    }
    
    func setupViews () {
        initViews()
        
        backgroundView.frame = overlayWindow.frame
        backgroundView.backgroundColor = stopButtonColor
        overlayWindow.addSubview(backgroundView)
        
        progressBar.frame = CGRect(x: 16, y: (UIScreen.main.bounds.height / 2) - 3, width: UIScreen.main.bounds.width - 32, height: 6)
        
        
        backgroundView.addSubview(progressBar)
        
        overlayWindow.windowLevel = UIWindow.Level(CGFloat.greatestFiniteMagnitude)
        
    }
    
    
    
    func hide() {
        DispatchQueue.main.async {
            
            self.backgroundView.transform = CGAffineTransform(translationX:0, y: -30)
            self.overlayWindow.backgroundColor = .clear
            self.overlayWindow.isHidden = true
            self.backgroundView.isHidden = true
            self.backgroundView.transform = CGAffineTransform.identity;
            
        }
        
    }
    
    @objc func stopRecording() {
        onStopClick?()
    }
    
    func show() {
        DispatchQueue.main.async {
            self.timeSpent = 0
            if (self.time == 0) {
                self.progressBar.progress = 1
                return
            }
            self.progressBar.progress = 0
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                self.timeSpent += 1
                self.progressBar.progress = self.timeSpent / self.time
                
                if (self.time == self.timeSpent) {
                    timer.invalidate()
                }
            }
            self.backgroundView.transform = CGAffineTransform(translationX: 0, y: -30)
            self.backgroundView.backgroundColor = self.stopButtonColor
            self.overlayWindow.isHidden = false
            self.backgroundView.isHidden = false
            self.overlayWindow.makeKeyAndVisible()
            self.backgroundView.transform = CGAffineTransform.identity
            
        }
        
    }
}
