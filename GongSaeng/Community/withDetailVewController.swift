//
//  withDetailViewController.swift
//  community
//
//  Created by 유경민 on 2021/11/04.
//

import UIKit

class withDetailViewController: UIViewController {
    var postDataList:[(String, String, String, String)] = [
    ("profileImage_0","로제떡볶이","1시간 전","자요! 7시에 엘리베이터 앞에서 만나요."),
    ("profileImage_0","roopre","1시간 전","자요! 7시에 엘리베이터 앞에서 만나요.")
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
extension withDetailViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "withCommentCell2", for: indexPath) as! withCommentCell
        
        cell.name?.text = postDataList[indexPath.row].1
        cell.time?.text = postDataList[indexPath.row].2
        cell.comment?.text = postDataList[indexPath.row].3
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDataList.count
    }
}

class withCommentCell : UICollectionViewCell
{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comment: UILabel!
    
}
