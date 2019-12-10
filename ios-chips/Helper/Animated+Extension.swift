//
//  Animated+Extension.swift
//  ios-chips
//
//  Created by DU on 12/8/19.
//

import UIKit
import Foundation

class AnimatedBase: NSObject {
    
    static let shared = AnimatedBase()
    override private init() { }
    
    struct AnimatedKeys {
        static let scale = "transform.scale"
    }
    
    // Animation Types
    private func bounce(repeatCount: Float, duration: TimeInterval) -> CAKeyframeAnimation {
        let bounce = CAKeyframeAnimation(keyPath: AnimatedKeys.scale)
        bounce.values = [1.0, 1.35, 0.95, 1.12, 0.95, 1.01, 1.0]
        bounce.duration = duration
        bounce.repeatCount = repeatCount
        bounce.calculationMode = .cubic
        return bounce
    }
    
    public func animatedTabbar(tabbar: UITabBar, tabbarIndex: Int, repeatCount: Float) {
        if let imageSelected: UIImageView = tabbar.subviews[tabbarIndex+1].subviews.first as? UIImageView {
            imageSelected.layer.add(self.bounce(repeatCount: repeatCount, duration: TimeInterval(0.5)), forKey: nil)
        }
    }
}
