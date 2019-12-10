//
//  HomeVC.swift
//  ios-chips
//
//  Created by DU on 12/8/19.
//

import UIKit

class HomeVC: BaseVC {

    // MARK: - IBOutlet
    @IBOutlet private weak var searchBarView: SearchBarView!
    @IBOutlet private weak var resultCollectionView: UICollectionView!
    @IBOutlet private weak var addedCollectionView: UICollectionView!
    @IBOutlet private weak var collapseButton: UIButton!
    @IBOutlet private weak var noJobDescView: UIView!
    @IBOutlet private weak var addedJobDescView: UIView!
    
    // MARK: - Properties
    private let homePresenter = HomePresenter()
    private var listJob = [JobsObject]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateNavigation(isHidden: true)
    }
    
    // MARK: - Initialization Method
    private func setupUI() {
        searchBarView.shadow(color: .black, offset: .zero, opacity: 0.1, radius: 1)
        
        // Delegation
        searchBarView.delegate = self
        homePresenter.delegate = self
        
        // Register cell
        resultCollectionView.register(JobsItem.self)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
               
        let collectionViewFlowLayout = CollectionViewCenterLayout()
        collectionViewFlowLayout.estimatedItemSize = CGSize(width: 100, height: 40)
        resultCollectionView.collectionViewLayout = collectionViewFlowLayout
        resultCollectionView.contentInsetAdjustmentBehavior = .always
        
        addedJobDescView.isHidden = true
    }
    
    private func setupData() { }
    
    // MARK: - Private Method
    // MARK: - Public Method
    // MARK: - Target
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - IBAction
    @IBAction private func touchUpInsideCollapse(_ sender: UIButton) {
        collapseButton.isSelected.toggle()
    }
}

// MARK: - HomeDelegate
extension HomeVC: HomeDelegate {
    func getJobsListSuccessed(data: [JobsObject]?) {
        searchBarView.transformSearchImageView(isLoading: false)
        if let data = data {
            listJob.removeAll()
            listJob = data
        }
        resultCollectionView.reloadData()
    }
    
    func getJobsListFailed(message: String) {
        print("DEBUG: ---- \(message)")
        searchBarView.transformSearchImageView(isLoading: false)
    }
}

// MARK: - SearchBarDelegate
extension HomeVC: SearchBarDelegate {
    func searchBarView(view: SearchBarView, textFieldDidChange text: String) {
        if !text.isEmpty {
            homePresenter.getListJobs(beginsWith: text)
            searchBarView.transformSearchImageView(isLoading: true)
        } else {
            
        }
    }
    
    func searchBarView(view: SearchBarView, textFieldShouldReturn: Bool) {
        self.dismissKeyboard()
    }
}

// MARK: - ExpertiseDelegate
extension HomeVC: ExpertiseDelegate {
    func expertiseViewController(expertiseVC: ExpertiseVC, didSelectButtonAdd andValue: ExpertiseObject) {
        
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listJob.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeue(JobsItem.self, forIndexPath: indexPath)
        if listJob.count > indexPath.count {
            item.setupUI(data: listJob[indexPath.item])
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listJob.count > indexPath.count {
            let expertiseVC = ExpertiseVC(jobObject: listJob[indexPath.item])
            expertiseVC.delegate = self
            AppDelegate.shared?.baseTabbar.present(expertiseVC, animated: true)
        }
    }
}
