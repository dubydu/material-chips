//
//  ActivityIndicatorView.swift
//  ios-chips
//
//  Created by DU on 12/13/19.
//

import UIKit

class ActivityIndicatorView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containActivityIndicatorView: UIView!
    
    // MARK: - Properties
    
    // MARK: - Initialization Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed("ActivityIndicatorView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor)
        
        setupActivityIndicatorView()
    }
    
    // MARK: - Private Method
    private func setupActivityIndicatorView() {
        let imageView = UIImageView(image: UIImage.gifImageWithName("ballProgressView"))
        containActivityIndicatorView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.anchor(top: containActivityIndicatorView.topAnchor, bottom: containActivityIndicatorView.bottomAnchor, left: containActivityIndicatorView.leftAnchor, right: containActivityIndicatorView.rightAnchor)
    }
}
