//
//  ShimmerView.swift
//  Mad
//
//  Created by MAC on 14/04/2021.
//



import Foundation
import UIKit

class ShimmerView: UIView {
    
    //enum for shimmer direction
    enum Direction: Int {
        case topToBottom = 0
        case bottomToTop
        case leftToRight
        case rightToLeft
        case leftDiagonally
        case rightDiagonally
    }
    
    // MARK: - Colors
    var gradientColorOne : CGColor = UIColor(white: 0.75, alpha: 1.0).cgColor
    
    var gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
    
    // MARK: - Views
    var gradientLayer:CAGradientLayer?
    
    // MARK: - Properties
    @IBInspectable var isShimmering: Bool = false {
        didSet{
            if isShimmering {
                startAnimating()
            }else {
                stopAnimation()
            }
            self.updateUI()
        }
    }
    
    var direction: Direction = .leftDiagonally

    static var globalTimer: Timer?
    
    

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.updateUI()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isShimmering {
            gradientLayer?.frame = self.bounds
            gradientLayer?.removeAnimation(forKey: "locations")
            self.startAnimating()
        }
        self.updateUI()
    }
    
    func updateUI(){
        self.isHidden = !isShimmering
    }
    
    // MARK: - Create Views
    func addGradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        
        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            
            //Left to right
            //        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        //        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .leftDiagonally:
            
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.2)
        case .rightDiagonally:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: -0.2)
        }
        
        
        //Left to right diagonally
        
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        //        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.locations = [0.3, 0.5, 0.7]
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
        
        return gradientLayer
    }
    
    
    // MARK: - Animations
    func addAnimation() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0 ]
        animation.repeatCount = .infinity
        animation.duration = 2
        animation.beginTime = CFTimeInterval() + self.remiaingTime()
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func startAnimating() {
        
        let gradientLayer = addGradientLayer()
        let animation = addAnimation()
        
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
    
    
    func stopAnimation() {
        self.gradientLayer?.removeFromSuperlayer()
    }
    
    // MARK: - Timer
    static func setupGlobalTimer(){
        if globalTimer != nil {
            return
        }
        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {_ in
            
        })
        self.globalTimer = timer
    }
    
    
    func remiaingTime() -> TimeInterval {
        ShimmerView.setupGlobalTimer()
        guard let timer = ShimmerView.globalTimer else {return 0}
        let fireDate = timer.fireDate
        let nowDate = NSDate()
        let remainingTimeInterval = nowDate.timeIntervalSince(fireDate)
        return remainingTimeInterval
    }
}
