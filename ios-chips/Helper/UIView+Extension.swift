//
//  UIView+Extension.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let borderColor = layer.borderColor {
                return UIColor(cgColor: borderColor)
            } else {
                return UIColor.white
            }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 1, height: 1)
            layer.shadowOpacity = 0.4
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var innerShadow: CGFloat {
        get {
            return 0
        }
        set {
            // remove CAGradientLayer
            self.layer.sublayers?.forEach({ layer in
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            })
            
            // create CAGradientLayer
            let gradient: CAGradientLayer = CAGradientLayer()
            let backgroundColor = self.backgroundColor ?? UIColor.white
            gradient.colors = [backgroundColor.cgColor, backgroundColor.cgColor]
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height - newValue)
            self.layer.insertSublayer(gradient, at: 0)
            
            // shadow for CAGradientLayer
            gradient.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            gradient.shadowOffset = CGSize(width: 0, height: newValue)
            gradient.shadowOpacity = 1
            gradient.masksToBounds = false
            gradient.shadowRadius = 0
            gradient.cornerRadius = self.cornerRadius
        }
    }
}

// MARK: - Auto layout
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat = 0, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat = 0, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat = 0, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
    }
    
    func shadow(color: UIColor = .black, offset: CGSize = .zero, opacity: Float = 0.3, radius: CGFloat = 3.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}
