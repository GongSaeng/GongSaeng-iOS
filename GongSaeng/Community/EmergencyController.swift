//
//  EmergencyController.swift
//  community
//
//  Created by 유경민 on 2021/09/30.
//

import UIKit

class EmergencyController: UIViewController {
    
    var postDataList:[(String,String,String,String,String,String,Int)]    =
    [
    ("주방","지금 주방에 물이 새요!!","주방에 물샙니다... 일단 대야 가져다 놓긴 했는데 빨리 대처가 필요할 듯 합니다.","profileImage_0","소라소라게","4분전",0),
    ("기타","여자화장실 3번째칸 물 안내려가요.","3층 여자화장실 3번째칸 물이 안내려가요. 빨른 대처 부탁드립니다.","profileImage_0","소녀소녀녀","일주일 전",5),
    ("주방","살려줘","살려주세요","profileImage_0","루프리텔캄","방금",99)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func back_pop(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

extension EmergencyController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell2", for: indexPath) as! emergency_cell
        cell.kind?.text=postDataList[indexPath.row].0
        //cell.profileimage?
        cell.title?.text=postDataList[indexPath.row].1
        cell.contents?.text=postDataList[indexPath.row].2
        cell.user_name?.text=postDataList[indexPath.row].4
        cell.time?.text=postDataList[indexPath.row].5
        cell.comments_num?.text = String(postDataList[indexPath.row].6)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDataList.count
    }
}

class emergency_cell: UICollectionViewCell
{
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var comments_num: UILabel!
}
