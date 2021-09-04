//
//  MateViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class MateViewController: UIViewController {
    
    let viewModel: MateViewModel = MateViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func lookAtAllThingsButtonHandler(_ sender: Any) {
        let sb = UIStoryboard(name: "Mate", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "MateListViewController") as MateListViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension MateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfMates
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MateCell", for: indexPath) as? MateCell else {
            return UICollectionViewCell()
        }
        cell.updateUI(at: viewModel.indexOfMate(at: indexPath.item))
        return cell
    }
}

extension MateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.bounds.height
        let width: CGFloat = height * 224 / 252
        return CGSize(width: width, height: height)
    }
}
