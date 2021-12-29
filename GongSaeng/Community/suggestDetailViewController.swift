//
//  suggestDetailViewController.swift
//  community
//
//  Created by 유경민 on 2021/11/05.
//

import UIKit

class suggestDetailViewController: UIViewController {
    var postDataList:[(String,String,String)] = [
        ("관리자","1시간 전","확인했습니다. 빠르게 복구하도록 하겠습니다."),
        ("관리자","1시간 전","확인했습니다. 빠르게 복구하도록 하겠습니다."),
        ("관리자","1시간 전","확인했습니다. 빠르게 복구하도록 하겠습니다.")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension suggestDetailViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestCommentCell", for: indexPath) as! suggestCommentCell
        
        cell.name?.text = postDataList[indexPath.row].0
        cell.time?.text = postDataList[indexPath.row].1
        cell.comment?.text = postDataList[indexPath.row].2
        return cell
    }
}

class suggestCommentCell: UICollectionViewCell
{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comment: UILabel!
    
}
