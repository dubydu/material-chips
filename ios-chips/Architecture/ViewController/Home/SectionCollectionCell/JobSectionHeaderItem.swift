//
//  JobSectionHeaderItem.swift
//  ios-chips
//
//  Created by DU on 12/12/19.
//

import UIKit

class JobSectionHeaderItem: UICollectionReusableView {
    
    @IBOutlet private weak var jobTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
     
    func setupUI(jobTitle: String) {
        jobTitleLabel.text = jobTitle
    }
     
    static var indentifier: String {
        return String(describing: self)
    }
     
    static var nib: UINib {
        return UINib(nibName: indentifier, bundle: nil)
    }
}
