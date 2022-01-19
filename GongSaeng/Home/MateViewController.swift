//
//  MateViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class MateViewController: UIViewController {
    
//    let viewModel: MateViewModel = MateViewModel()
    private var mates = [Mate]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DEBUG: MateViewController viewDidLoad..")
        fetchMates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("DEBUG: MateViewController ViewWillApper..")
//        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: API
    private func fetchMates() {
        print("DEBUG: Called fetchMates()..")
        HomeNetworkManager.fetchMate(department: "한국장학재단") { [weak self] mates in
            guard let self = self else { return }
            self.mates = mates
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: Actions
    @IBAction func lookAtAllThingsButtonHandler(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Mate", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MateListViewController") as! MateListViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.hidesBottomBarWhenPushed = true
        if mates.isEmpty {
            fetchMates()
        }
        viewController.mates = self.mates
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

extension MateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 224, height: 252)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}
