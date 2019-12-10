//
//  ExpertiseVC.swift
//  ios-chips
//
//  Created by DU on 12/10/19.
//

import UIKit
import SI1_RatingView

protocol ExpertiseDelegate: NSObjectProtocol {
    func expertiseViewController(expertiseVC: ExpertiseVC, didSelectButtonAdd andValue: ExpertiseObject)
}

class ExpertiseObject {
    var ratingValue: Double?
    var comment: String?
    
    init(ratingValue: Double?, comment: String?) {
        self.ratingValue = ratingValue
        self.comment = comment
    }
}

class ExpertiseVC: BaseVC {

    // MARK: - IBOutlet
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var commentTextView: CustomTextView!
    
    // MARK: - Properties
    weak var delegate: ExpertiseDelegate?
    private var jobObject: JobsObject?
    private var expertiseObject: ExpertiseObject?
    private var ratingValue: Double?
    private var commentValue: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    convenience init(jobObject: JobsObject) {
        self.init()
        self.jobObject = jobObject
        self.updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configurationRatingView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateUI()
    }
    
    // MARK: - Initialization Method
    private func configurationRatingView() {
        ratingView.delegate = self
        commentTextView.delegate = self
        
        ratingView.type = .fullRating
    }
    
    // MARK: - Private Method
    private func updateUI() {
        guard isViewLoaded, let jobObject = jobObject else { return }
        self.commentTextView.placeholder = "Add comments to skill \(jobObject.suggestion ?? "")"
    }
    
    // MARK: - Public Method
    // MARK: - Target
    
    // MARK: - IBAction
    @IBAction private func touchUpInsideClose(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }
    }
    
    @IBAction private func touchUpInsideAdd(_ sender: UIButton) {
        if let ratingValue = ratingValue, let commentValue = commentValue {
            self.delegate?.expertiseViewController(expertiseVC: self, didSelectButtonAdd: ExpertiseObject(ratingValue: ratingValue, comment: commentValue))
        } else {
            
        }
    }
}

// MARK: - RatingViewDelegate
extension ExpertiseVC: RatingViewDelegate {
    func ratingView(_ ratingView: RatingView, didUpdate rating: Double) {
        self.ratingValue = rating
    }
    
    func ratingView(_ ratingView: RatingView, isUpdating rating: Double) {
    }
}

// MARK: - UITextViewDelegate
extension ExpertiseVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.commentValue = textView.text
    }
}
