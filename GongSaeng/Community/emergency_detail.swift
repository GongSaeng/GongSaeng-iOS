//
//  emergency_detail.swift
//  community
//
//  Created by 유경민 on 2021/09/30.
//

import UIKit


class emergency_detail: UIViewController {
    var postDataList: [(String, String, String, String)] =
    [("profileImage_0","관리자","1시간 전","확인했습니다. 빠르게 복구하도록 하겠습니다."),
     ("profileImage_0","roopre","방금 전","시끄러어어어"),
     ("profileImage_0","roopre","방금 전","시끄러어어어")
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
extension emergency_detail: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postDataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentcell", for: indexPath) as! commentcell
        cell.user.text = postDataList[indexPath.row].1
        cell.comment_content.text = postDataList[indexPath.row].3
        cell.time.text = postDataList[indexPath.row].2
        
        return cell
    }
}

class commentcell: UICollectionViewCell
{
    
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var comment_content: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var image: UIImageView!
}
