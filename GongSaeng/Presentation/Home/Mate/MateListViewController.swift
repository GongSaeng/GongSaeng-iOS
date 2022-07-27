//
//  MateListViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

final class MateListViewController: UIViewController {
    
//    let viewModel: MateViewModel = MateViewModel()
    // MARK: Properties
    var mates = [Mate]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: Actions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Helpers
    private func configureNavigationBar() {
        navigationItem.title = "공생메이트"
        navigationController?.navigationBar.tintColor = UIColor(white: 0, alpha: 0.8)
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium)]
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.topItem?.title = ""
    }
    
}

// MARK: UICollectionViewDataSource
extension MateListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.numOfMates
        return mates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as? MateCell else {
            return MateCell()
        }
        let mate = mates[indexPath.item]
        cell.viewModel = MateCellViewModel(mate: mate)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MateListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSpacing: CGFloat = CGFloat(16.0)
        let width: CGFloat = view.bounds.width - 2 * sideSpacing
        let height: CGFloat = CGFloat(170.0)
        return CGSize(width: width, height: height)
    }
}
