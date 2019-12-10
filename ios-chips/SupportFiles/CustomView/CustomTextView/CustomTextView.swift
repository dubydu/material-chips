//
//  CustomTextView.swift
//  ios-chips
//
//  Created by DU on 12/10/19.
//

import UIKit

class CustomTextView: UITextView {
    
    @IBInspectable var placeholder: String? {
        didSet {
            self.updatePlaceHolder()
        }
    }
    
    private var placeHolderLabel: UILabel?
    
    override var text: String! {
        didSet {
            self.updatePlaceHolder()
        }
    }
    
    // MARK: - Initialization Method
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    
    // MARK: - Private Method
    private func initView() {
        // setup place holder
        setupPlaceHolder()
    }
    
    private func setupPlaceHolder() {
        placeHolderLabel = UILabel()
        placeHolderLabel?.text = placeholder ?? ""
        placeHolderLabel?.numberOfLines = 0
        placeHolderLabel?.lineBreakMode = .byWordWrapping
        placeHolderLabel?.sizeToFit()
        
        placeHolderLabel?.font = self.font
        placeHolderLabel?.textColor = UIColor.lightGray
        placeHolderLabel?.isHidden = self.text.count > 0
        
        if let placeHolderLabel = placeHolderLabel {
            self.addSubview(placeHolderLabel)
        }
        self.resizePlaceholder()
        
        // Detect when text change
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlaceHolder), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func resizePlaceholder() {
        let labelX = self.textContainer.lineFragmentPadding
        let labelY = self.textContainerInset.top
        let labelWidth = self.frame.width - (labelX * 2)
        let labelHeight = CGFloat.greatestFiniteMagnitude
        placeHolderLabel?.frame.size = CGSize(width: labelWidth, height: labelHeight)
        placeHolderLabel?.sizeToFit()
        placeHolderLabel?.frame.origin = CGPoint(x: labelX, y: labelY)
    }
    
    @objc private func updatePlaceHolder() {
        placeHolderLabel?.text = placeholder
        placeHolderLabel?.sizeToFit()
        self.resizePlaceholder()
        placeHolderLabel?.isHidden = !self.text.isEmpty
    }
}
