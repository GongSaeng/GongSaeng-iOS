//
//  TempDetail2ViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/24.
//

import UIKit
import Kingfisher

class TempDetail2ViewController: UIViewController {
    
    @IBOutlet weak var postingImageView: UIImageView!
    @IBOutlet weak var writerImageView: UIImageView!
    
    @IBOutlet weak var participant1: UIImageView!
    @IBOutlet weak var participant2: UIImageView!
    @IBOutlet weak var participant3: UIImageView!
    @IBOutlet weak var empty1: UIImageView!
    @IBOutlet weak var emptyContentView: UIView!
    
    @IBOutlet weak var postingContent: UIView!
    @IBOutlet weak var participantContent1: UIView!
    @IBOutlet weak var participantContent2: UIView!
    @IBOutlet weak var participantContent3: UIView!
    
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
                $0?.clipsToBounds = true
                $0?.contentMode = .scaleAspectFill
                $0?.layer.cornerRadius = participant1.frame.height / 2
                $0?.layer.borderWidth = 1.0
                $0?.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
            }
        participantContent1.layer.borderColor = UIColor(displayP3Red: 1, green: 208/255, blue: 101/255, alpha: 1).cgColor
        participantContent1.layer.borderWidth = 2.0
        
        participant1.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "32"))
        participant2.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "6"))
        participant3.kf.setImage(with: URL(string: SERVER_IMAGE_URL + "25"))
        
//        emptyContentView.
//        empty1.layer.borderWidth = 2.0
//        empty1.layer.borderColor = UIColor.gray.cgColor
        
//        empty1.la
        
//        participantContent2.layer.cornerRadius = participantContent2.frame.height / 2
        [postingContent, participantContent1, participantContent2, participantContent3, emptyContentView]
            .forEach {
                $0?.layer.cornerRadius = participantContent1.frame.height / 2
                $0?.layer.masksToBounds = false
                $0?.layer.shadowColor = UIColor.black.cgColor
                $0?.layer.shadowOffset = CGSize(width: 0, height: 0.5)
                $0?.layer.shadowOpacity = 0.8
                $0?.layer.shadowRadius = 1.0
                
                if $0 == postingImageView {
                    $0?.layer.shadowOffset = CGSize(width: 0, height: 0.7)
                }
            }
        
        
        buttonContentView.layer.cornerRadius = 8.0
//        buttonContentView.layer.borderWidth = 1.5
//        buttonContentView.layer.borderColor = UIColor(named: "colorPaleOrange")?.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.popViewController(animated: true)
    }
}
