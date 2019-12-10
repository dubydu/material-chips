//
//  BaseVC.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import UIKit

class BaseVC: UIViewController {

    // MARK: - IBOutlet
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Initialization Method
    
     // MARK: - Private Method
    private func setNavigationBar(title: String?, leftBarButtons: [UIBarButtonItem]?, rightBarButtons: [UIBarButtonItem]?) {
        self.navigationItem.title = title
        self.navigationItem.leftBarButtonItems = leftBarButtons
        self.navigationItem.rightBarButtonItems = rightBarButtons
    }
    
    // MARK: - Public Method
    func updateNavigation(title: String? = nil, isHidden: Bool) {
        self.navigationController?.setNavigationBarHidden(isHidden, animated: true)
        
        var listLeftButtons: [UIBarButtonItem] = []
        var listRightButtons: [UIBarButtonItem] = []
        setNavigationBar(title: title, leftBarButtons: listLeftButtons, rightBarButtons: listRightButtons)
    }
    
    // MARK: - Target
    // MARK: - IBAction

}
