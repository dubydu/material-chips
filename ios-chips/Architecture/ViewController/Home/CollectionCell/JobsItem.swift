//
//  JobsItem.swift
//  ios-chips
//
//  Created by DU on 12/9/19.
//

import UIKit

class JobsItem: UICollectionViewCell {

    @IBOutlet private weak var jobTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupUI(data: JobsObject) {
        jobTitleLabel.text = data.trimSuggestion()
        updateUI()
    }
    
    private func updateUI() {
        
    }
}
