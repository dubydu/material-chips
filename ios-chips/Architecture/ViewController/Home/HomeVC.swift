//
//  HomeVC.swift
//  ios-chips
//
//  Created by DU on 12/8/19.
//

import UIKit

enum ResultCollectionViewSectionType: Int, CaseIterable {
    case result = 0
    case related
}

class HomeVC: BaseVC {

    // MARK: - IBOutlet
    @IBOutlet private weak var searchBarView: SearchBarView!
    @IBOutlet private weak var containResultCollectionView: UIView!
    @IBOutlet private weak var activityIndicatorView: ActivityIndicatorView!
    @IBOutlet private weak var resultCollectionView: UICollectionView!
    @IBOutlet private weak var addedCollectionView: UICollectionView!
    @IBOutlet private weak var containAddedCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var collapseButton: UIButton!
    @IBOutlet private weak var noJobDescView: UIView!
    @IBOutlet private weak var jobAddedDescView: UIView!
    @IBOutlet private weak var jobAddedButton: UIButton!
    @IBOutlet private weak var viewStateButton: UIButton!
    
    // MARK: - Properties
    private let homePresenter = HomePresenter()
    private var listAllJob = [BaseJobObject]()
    private var listSearchedJob = [JobsObject]()
    private var listRelatedJob: RelatedJobsObject?
    private var listJobItemSelected = [ExpertiseObject]()
    private var jobAddedDescViewHeight: CGFloat = 40
    private var sectionResultTitle: String = ""
    private var itemAddedViewHorizontal: Bool = true
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateNavigation(isHidden: true)
        self.updateContainJobAddedView()
    }
    
    // MARK: - Initialization Method
    private func setupUI() {
        searchBarView.shadow(color: .black, offset: .zero, opacity: 0.1, radius: 1)
        
        // Delegation
        searchBarView.delegate = self
        homePresenter.delegate = self
        
        // Register cell
        resultCollectionView.register(JobsItem.self)
        resultCollectionView.register(JobSectionHeaderItem.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: JobSectionHeaderItem.indentifier)
        addedCollectionView.register(JobsSelectedItem.self)
        
        setupCollectionViews()
        
        jobAddedDescView.isHidden = true
    }
    
    private func setupCollectionViews() {
        [resultCollectionView, addedCollectionView].forEach { [weak self] (collectionView) in
            guard let `self` = self, let collectionView = collectionView else { return }
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let collectionViewFlowLayout = (collectionView == addedCollectionView) ? itemAddedViewHorizontal ? UICollectionViewFlowLayout() : CollectionViewCenterLayout() : CollectionViewCenterLayout()
            collectionViewFlowLayout.estimatedItemSize = CGSize(width: 200, height: (collectionView == resultCollectionView) ? 50 : 36)
            collectionView.collectionViewLayout = collectionViewFlowLayout
            collectionView.contentInsetAdjustmentBehavior = .always
            collectionViewFlowLayout.scrollDirection = (collectionView == addedCollectionView) ? itemAddedViewHorizontal ? .horizontal : .vertical : .vertical
        }
    }
    
    private func setupData() {
        homePresenter.getListJobs(offset: 0, limit: 45)
    }
    
    private func resetData() {
    }
    
    // MARK: - Private Method
    private func updateUI() {
        // Update added collection view height
        containAddedCollectionViewHeight.constant = listJobItemSelected.isEmpty ? jobAddedDescViewHeight : (jobAddedDescViewHeight + (itemAddedViewHorizontal ? 50 : addedCollectionView.contentSize.height))
        updateContainJobAddedView()
        defaultAnimation()
    }
    
    private func updateContainJobAddedView() {
        jobAddedDescView.isHidden = listJobItemSelected.isEmpty
        noJobDescView.isHidden = !listJobItemSelected.isEmpty
        jobAddedButton.titleLabel?.text = "\(listJobItemSelected.count)"
    }
    
    // MARK: - Public Method
    
    // MARK: - Target
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - IBAction
    @IBAction private func touchUpInsideCollapse(_ sender: UIButton) {
        collapseButton.isSelected.toggle()
        containAddedCollectionViewHeight.constant = collapseButton.isSelected ? jobAddedDescViewHeight : (addedCollectionView.contentSize.height + jobAddedDescViewHeight)
        viewStateButton.isHidden = collapseButton.isSelected
        defaultAnimation()
    }
    
    @IBAction private func touchUpInsideViewState(_ sender: UIButton) {
        viewStateButton.isSelected.toggle()
        itemAddedViewHorizontal.toggle()
        setupCollectionViews()
        updateUI()
        addedCollectionView.reloadData()
    }
}

// MARK: - HomeDelegate
extension HomeVC: HomeDelegate {
    func getJobsListSuccessed(data: [JobsObject]?) {
        if let data = data {
            listSearchedJob.removeAll()
            listSearchedJob = data
        }
        
        if !listSearchedJob.isEmpty, let uuid = listSearchedJob[0].uuid {
            homePresenter.getListRelatedJobs(uuid: uuid)
            
            // Reset listBaseJobs
            listAllJob.removeAll()
            return
        }
        searchBarView.transformSearchImageView(isLoading: false)
    }
    
    func getJobsListFailed(message: String) {
        print("DEBUG: ---- \(message)")
        searchBarView.transformSearchImageView(isLoading: false)
    }
    
    func getRelatedJobsListSuccessed(data: RelatedJobsObject?) {
        listRelatedJob = data
        resultCollectionView.reloadData()
        searchBarView.transformSearchImageView(isLoading: false)
    }
    
    func getRelatedJobsListFailed(message: String) {
        print("DEBUG: ---- \(message)")
        searchBarView.transformSearchImageView(isLoading: false)
    }
    
    func getAllJobsListSuccessed(data: [BaseJobObject]?) {
        if let data = data {
            listAllJob = data.dropLast()
        }
        resultCollectionView.reloadData()
        activityIndicatorView.removeFromSuperview()
    }
    
    func getAllJobsListFailed(message: String) {
        print("DEBUG: ---- \(message)")
        activityIndicatorView.removeFromSuperview()
    }
}

// MARK: - SearchBarDelegate
extension HomeVC: SearchBarDelegate {
    func searchBarView(view: SearchBarView, textFieldDidChange text: String) {
        if !text.isEmpty {
            homePresenter.getListJobs(beginsWith: text)
            searchBarView.transformSearchImageView(isLoading: true)
            sectionResultTitle = text
        } else {
            
        }
    }
    
    func searchBarView(view: SearchBarView, textFieldShouldReturn: Bool) {
        self.dismissKeyboard()
    }
}

// MARK: - ExpertiseDelegate
extension HomeVC: ExpertiseDelegate {
    func expertiseViewController(expertiseVC: ExpertiseVC, didSelectButtonAdd value: ExpertiseObject) {
        self.listJobItemSelected.append(value)
        self.addedCollectionView.reloadData()
        
        addedCollectionView.performBatchUpdates({
            self.addedCollectionView.reloadData()
        }) { (finished) in
            self.updateUI()
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == resultCollectionView {
            return listSearchedJob.isEmpty ? 1 : ResultCollectionViewSectionType.allCases.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == resultCollectionView {
            guard let sectionType = ResultCollectionViewSectionType(rawValue: section) else { return 0 }
            switch sectionType {
            case .result:
                return listAllJob.isEmpty ? listSearchedJob.count : listAllJob.count
            case .related:
                return listRelatedJob?.relatedJobTitles?.count ?? 0
            }
        }
        
        if collectionView == addedCollectionView {
            return listJobItemSelected.count
        }
        
        return 0
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == resultCollectionView {
            guard let sectionType = ResultCollectionViewSectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
            let item = collectionView.dequeue(JobsItem.self, forIndexPath: indexPath)
            switch sectionType {
            case .result:
                if listAllJob.isEmpty {
                    if listSearchedJob.count > indexPath.item {
                        item.setupUI(jobsObject: listSearchedJob[indexPath.item])
                    }
                } else {
                    if listAllJob.count > indexPath.item {
                        item.setupUI(baseJobObject: listAllJob[indexPath.item])
                    }
                }
                return item
            case .related:
                if let listRelatedJob = listRelatedJob, let relatedJobTitles = listRelatedJob.relatedJobTitles, relatedJobTitles.count > indexPath.item {
                    item.setupUI(relatedJobTitleObject: relatedJobTitles[indexPath.row])
                }
                return item
            }
        }
        
        if collectionView == addedCollectionView {
            let item = collectionView.dequeue(JobsSelectedItem.self, forIndexPath: indexPath)
            if listJobItemSelected.count > indexPath.item {
                item.setupUI(itemAddedViewHorizontal: self.itemAddedViewHorizontal, data: listJobItemSelected[indexPath.item])
                item.delegate = self
            }
            return item
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == resultCollectionView {
            guard let sectionType = ResultCollectionViewSectionType(rawValue: indexPath.section) else { return }
            switch sectionType {
            case .result:
                if listSearchedJob.count > indexPath.count {
                    let expertiseVC = ExpertiseVC(jobObject: listSearchedJob[indexPath.item])
                    expertiseVC.delegate = self
                    AppDelegate.shared?.baseTabbar.present(expertiseVC, animated: true)
                }
            case .related:
                return
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return collectionView == resultCollectionView ? CGSize(width: UIScreen.main.bounds.width, height: listAllJob.isEmpty ? (listSearchedJob.isEmpty ? 0 : 50) : 50) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 0, bottom: 5, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: JobSectionHeaderItem.indentifier, for: indexPath) as! JobSectionHeaderItem
        guard let sectionType = ResultCollectionViewSectionType(rawValue: indexPath.section) else { return UICollectionReusableView() }
        headerView.setupUI(jobTitle: sectionType == .result ?
            (!listAllJob.isEmpty ? "All Jobs" :
            """
            Result for "\(sectionResultTitle)"
            """ ): "Related Job Categories")
        return headerView
    }
}

// MARK: JobsSelectedItemDelegate
extension HomeVC: JobsSelectedItemDelegate {
    func jobsSelectedItem(_ jobsSelectedItem: JobsSelectedItem, didSelectectAt ClearButton: Bool) {
        guard let indexPath = addedCollectionView.indexPath(for: jobsSelectedItem), listJobItemSelected.count > indexPath.item else { return }
        listJobItemSelected.remove(at: indexPath.item)
        addedCollectionView.reloadData()
        updateUI()
    }
}
