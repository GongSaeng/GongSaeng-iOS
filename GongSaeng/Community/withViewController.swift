//
//  withViewController.swift
//  community
//
//  Created by 유경민 on 2021/11/03.
//

import UIKit

class withViewController: UIViewController {
    
    var postDataList:[(String, String, String, String, String, String, Int)] =
    [
        ("recruiting","오늘 저녁 같이 시키실 분?","배달음식 같이 시켜서 나누실분 구합니다. 배송비 아껴요", "profileImage_0","러버공","4분전",0),
        ("recruiting","오늘 저녁 같이 시키실 분?","배달음식 같이 시켜서 나누실분 구합니다. 배송비 아껴요", "profileImage_0","roopre","4분전",0),
        ("recruiting","오늘 저녁 같이 시키실 분?","배달음식 같이 시켜서 나누실분 구합니다. 배송비 아껴요", "profileImage_0","onmywave","4분전",0),
        ("recruiting","오늘 저녁 같이 시키실 분?","배달음식 같이 시켜서 나누실분 구합니다. 배송비 아껴요", "profileImage_0","telcham","40분전",0),
        ("recruiting","오늘 저녁 같이 시키실 분?","배달음식 같이 시켜서 나누실분 구합니다. 배송비 아껴요", "profileImage_0","mywaves","42분전",0)
    ]
    
    @IBAction func button_backward(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
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

extension withViewController: UICollectionViewDataSource
{
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "withCell2", for: indexPath) as! withCell
        
        cell.title?.text = postDataList[indexPath.row].1
        cell.content?.text = postDataList[indexPath.row].2
        cell.name?.text = postDataList[indexPath.row].4
        cell.time?.text = postDataList[indexPath.row].5
        cell.comment_num?.text = String(postDataList[indexPath.row].6)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDataList.count
    }
}

class withCell: UICollectionViewCell
{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comment_num: UILabel!
    
}
