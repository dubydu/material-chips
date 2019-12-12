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
    
    func setupUI(jobsObject: JobsObject? = nil, relatedJobTitleObject: RelatedJobTitleObject? = nil) {
        if let jobsObject = jobsObject{
            jobTitleLabel.text = jobsObject.trimSuggestion()
        }
        
        if let relatedJobTitleObject = relatedJobTitleObject {
            jobTitleLabel.text = relatedJobTitleObject.trimTitle()
        }
        
        updateUI()
    }
    
    private func updateUI() {
        
    }
    
    static var indentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: indentifier, bundle: nil)
    }
}
