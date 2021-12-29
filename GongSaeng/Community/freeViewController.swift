//
//  freeViewController.swift
//  community
//
//  Created by 유경민 on 2021/11/17.
//

import UIKit

class freeViewController: UIViewController {
    
    var postDataList: [(String,String,String,String,String,Int)] =
    [
        ("게시판 제목이 들어갈 자리, 최대 여기까지 표시..","본문 내용은 최대 두 줄까지 보여주고 그 이후는 말줄임표, 시간은 몇분전, 몇시간전, 몇일전으로 보여주면 좋겠...","profileImage_0","닉네임","4분전",0),
        ("게시판 제목이 들어갈 자리, 최대 여기까지 표시..","본문 내용은 최대 두 줄까지 보여주고 그 이후는 말줄임표, 시간은 몇분전, 몇시간전, 몇일전으로 보여주면 좋겠...","profileImage_0","닉네임","4분전",0),
        ("게시판 제목이 들어갈 자리, 최대 여기까지 표시..","본문 내용은 최대 두 줄까지 보여주고 그 이후는 말줄임표, 시간은 몇분전, 몇시간전, 몇일전으로 보여주면 좋겠...","profileImage_0","닉네임","4분전",0),
        ("게시판 제목이 들어갈 자리, 최대 여기까지 표시..","본문 내용은 최대 두 줄까지 보여주고 그 이후는 말줄임표, 시간은 몇분전, 몇시간전, 몇일전으로 보여주면 좋겠...","profileImage_0","닉네임","4분전",0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func button_backward(_ sender: UIButton) {
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




class free_cell: UICollectionViewCell
{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var comments_num: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
}

extension freeViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "free_cell", for: indexPath) as! free_cell
        cell.title?.text = postDataList[indexPath.row].0
        cell.content?.text = postDataList[indexPath.row].1
        cell.user_name?.text = postDataList[indexPath.row].3
        cell.time?.text = postDataList[indexPath.row].4
        cell.comments_num?.text = String(postDataList[indexPath.row].5)
        
        return cell
    }
        
}

extension freeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let size = CGSize(width: width, height: 150)
        return size
    }
}
