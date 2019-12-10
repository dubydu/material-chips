//
//  SearchBarView.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import UIKit

protocol SearchBarDelegate: NSObjectProtocol {
    func searchBarView(view: SearchBarView, textFieldDidChange text: String)
    func searchBarView(view: SearchBarView, textFieldShouldReturn: Bool)
}

class SearchBarView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchImageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    weak var delegate: SearchBarDelegate?
    
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
        Bundle.main.loadNibNamed("SearchBarView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor)
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        transformSearchImageView(isLoading: false)
    }
    
    // MARK: - Private Method
    
    // MARK: - Public Method
    func transformSearchImageView(isLoading: Bool) {
        searchImageView.alpha = isLoading ? 0 : 1
        activityIndicatorView.alpha = isLoading ? 1 : 0
        
        isLoading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
    
    // MARK: - Target
    @objc func textFieldDidEndTyping(_ textField: UITextField) {
        if let text = textField.text {
            self.delegate?.searchBarView(view: self, textFieldDidChange: text)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) { }
    
    // MARK: - IBAction
}

// MARK: - UITextFieldDelegate
extension SearchBarView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(textFieldDidEndTyping), object: textField)
        
        self.perform(#selector(textFieldDidEndTyping), with: textField, afterDelay: 1)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.searchBarView(view: self, textFieldShouldReturn: true)
        return true
    }
}
