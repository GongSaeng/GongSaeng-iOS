//
//  TempDetailViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/24.
//

import UIKit
import Kingfisher

class TempDetailViewController: UIViewController {
    
    @IBOutlet weak var postingImageView: UIImageView!
    @IBOutlet weak var writerImageView: UIImageView!
    
    @IBOutlet weak var participant1: UIImageView!
    @IBOutlet weak var participant2: UIImageView!
    @IBOutlet weak var participant3: UIImageView!
    
    @IBOutlet weak var buttonContentView: UIView!
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
        let commentInputAccesoryView = CommentInputAccessoryView(frame: frame)
//        commentInputAccesoryView.delegate = self
        return commentInputAccesoryView
    }()
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "번개"
        navigationController?.navigationBar.isHidden = true
        
        postingImageView.contentMode = .scaleAspectFill
//        postingImageView.layer.cornerRadius = 10.0
        postingImageView.layer.borderWidth = 1.0
        postingImageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        postingImageView.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "34"))
        
        writerImageView.contentMode = .scaleAspectFill
        writerImageView.layer.cornerRadius = writerImageView.frame.height / 2
        writerImageView.layer.borderWidth = 1.0
        writerImageView.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        writerImageView.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "32"))
        
        [participant1, participant2, participant3]
            .forEach {
                $0?.contentMode = .scaleAspectFill
                $0?.layer.cornerRadius = participant1.frame.height / 2
                $0?.layer.borderWidth = 1.0
                $0?.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
            }
        participant1.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "32"))
        participant2.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "6"))
        participant3.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "25"))
        
        buttonContentView.layer.cornerRadius = 8.0
//        buttonContentView.layer.borderWidth = 1.5
//        buttonContentView.layer.borderColor = UIColor(named: "colorPaleOrange")?.cgColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.popViewController(animated: true)
    }
}
