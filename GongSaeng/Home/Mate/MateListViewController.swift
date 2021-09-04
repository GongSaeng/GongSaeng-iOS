//
//  MateListViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/07.
//

import UIKit

class MateListViewController: UIViewController {
    
    let viewModel: MateViewModel = MateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as? MateDetailViewController
            if let index = sender as? Int {
                vc?.selectMate = viewModel.indexOfMate(at: index)
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension MateListViewController: UICollectionViewDataSource {
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

extension MateListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath.item)
    }
}

extension MateListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSpacing: CGFloat = CGFloat(16.0)
        let width: CGFloat = view.bounds.width - 2 * sideSpacing
        let height: CGFloat = CGFloat(170.0)
        return CGSize(width: width, height: height)
    }
}
