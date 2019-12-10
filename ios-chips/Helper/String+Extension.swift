//
//  String+Extension.swift
//  ios-chips
//
//  Created by DU on 12/10/19.
//

import UIKit
import Foundation

extension String {
    func getAttributed(font: UIFont = UIFont.systemFont(ofSize: 14), foregroundColor: UIColor = UIColor(hexString: "#283C50"),lineSpacing: CGFloat = 0, textAlign : NSTextAlignment = .left) -> NSMutableAttributedString {
        //atributionString
        let textAtribution = [
            NSAttributedString.Key.foregroundColor : foregroundColor,
            NSAttributedString.Key.font : font
            ] as [NSAttributedString.Key : Any]
        let attrString = NSMutableAttributedString(string: self, attributes: textAtribution)
        //line spacing
        if lineSpacing != 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            if textAlign != .left{
                paragraphStyle.alignment = textAlign
            }
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                    value:paragraphStyle,
                                    range:NSMakeRange(0, attrString.length))
        }
        return  attrString
    }
}
