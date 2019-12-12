//
//  JobsSelectedItem.swift
//  ios-chips
//
//  Created by DU on 12/10/19.
//

import UIKit

protocol JobsSelectedItemDelegate: NSObjectProtocol {
    func jobsSelectedItem(_ jobsSelectedItem: JobsSelectedItem, didSelectectAt ClearButton: Bool)
}

class JobsSelectedItem: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var jobTitleLabel: UILabel!
    
    // MARK: - Properties
    weak var delegate: JobsSelectedItemDelegate?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Initialization Method
    // MARK: - Private Method
    
    // MARK: - Public Method
    func setupUI(itemAddedViewHorizontal: Bool, data: ExpertiseObject) {
        jobTitleLabel.text = itemAddedViewHorizontal ? data.jobTitle : data.trimJobTitle()
        updateUI()
    }
    
    private func updateUI() {
        
    }
    
    // MARK: - Target
    
    // MARK: - IBAction
    @IBAction private func touchUpInsideClear(_ sender: UIButton) {
        delegate?.jobsSelectedItem(self, didSelectectAt: true)
    }
}
