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
        
        fetchMates()
    }
    
    // MARK: API
    private func fetchMates() {
        MateNetwork.fetchMate(department: "한국장학재단") { mates in
            self.mates = mates
            print("DEBUG: \(mates)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: Helpers
    
    
    // MARK: Actions
    @IBAction func lookAtAllThingsButtonHandler(_ sender: Any) {
        let sb = UIStoryboard(name: "Mate", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "MateListViewController") as MateListViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension MateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as? MateCell else {
            return UICollectionViewCell()
        }
        let mate = mates[indexPath.item]
        cell.viewModel = MateCellViewModel(mate: mate)
//        cell.updateUI(at: viewModel.indexOfMate(at: indexPath.item))
        return cell
    }
}

extension MateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height: CGFloat = collectionView.bounds.height
//        let width: CGFloat = height * 224 / 252
        return CGSize(width: 224, height: 252)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
}
