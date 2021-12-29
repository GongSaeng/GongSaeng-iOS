//
//  suggestViewController.swift
//  community
//
//  Created by 유경민 on 2021/11/04.
//

import UIKit

class suggestViewController: UIViewController {
    
    var postDataList :[(String,String,String,String,String,String,Int)] = [
    ("소음","늦은 밤 소음이 너무 심합니다.","늦은 밤 계단, 복도에서 대화하시는 소리가 너무 시끄럽습니다 ㅠㅠ 조금만 주의해주시면 감사하겠습니다.", "profile_Image0","닉네임","4분전",0),
    ("소음","늦은 밤 소음이 너무 심합니다.","늦은 밤 계단, 복도에서 대화하시는 소리가 너무 시끄럽습니다 ㅠㅠ 조금만 주의해주시면 감사하겠습니다.", "profile_Image0","닉네임","4분전",0),
    ("소음","늦은 밤 소음이 너무 심합니다.","늦은 밤 계단, 복도에서 대화하시는 소리가 너무 시끄럽습니다 ㅠㅠ 조금만 주의해주시면 감사하겠습니다.", "profile_Image0","닉네임","4분전",0),
    ("소음","늦은 밤 소음이 너무 심합니다.","늦은 밤 계단, 복도에서 대화하시는 소리가 너무 시끄럽습니다 ㅠㅠ 조금만 주의해주시면 감사하겠습니다.", "profile_Image0","닉네임","4분전",0)
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

extension suggestViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestCell", for: indexPath) as! suggestCell
        cell.category?.text = postDataList[indexPath.row].0
        cell.title?.text = postDataList[indexPath.row].1
        cell.content?.text = postDataList[indexPath.row].2
        cell.name?.text = postDataList[indexPath.row].4
        cell.time?.text = postDataList[indexPath.row].5
        cell.comment_num?.text = String(postDataList[indexPath.row].6)
        
        return cell
    }
}

class suggestCell: UICollectionViewCell
{
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comment_num: UILabel!
    
}
