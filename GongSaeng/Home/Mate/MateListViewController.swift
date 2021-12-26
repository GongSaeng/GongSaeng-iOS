//
//  MateListViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class MateListViewController: UIViewController {
    
//    let viewModel: MateViewModel = MateViewModel()
    // MARK: Properties
    var mates = [Mate]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: Actions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            return UICollectionViewCell()
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
