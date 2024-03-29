//
//  FinishUsingPopUpViewController.swift
//  GongSaeng
//
//  Created by 정동천 on 2021/10/02.
//

import UIKit

class FinishUsingPopUpViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var doneUsingButton: UIButton!
    
    @IBOutlet weak var popUpViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [popUpView, stopButton, doneUsingButton].forEach {
            $0?.layer.cornerRadius = 10
        }
        stopButton.layer.borderWidth = 1
        stopButton.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.4039215686, blue: 0.3803921569, alpha: 1)
        
        popUpViewBottomConstraint.constant -= popUpView.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.popUpView.layer.position.y -= self.popUpView.frame.height
            self.popUpViewBottomConstraint.constant = -50
        }
    }
    
    @IBAction func stopButtonTappeed(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func doneUsingButtonTapped(_ sender: UIButton) {
        guard let presentingViewController = self.presentingViewController else { return }
        dismiss(animated: false) {
            let storyBoard = UIStoryboard.init(name: "ReservationPopUp", bundle: nil)
            let popUpViewController = storyBoard.instantiateViewController(identifier: "FinishedUsingPopUpViewController") as! FinishedUsingPopUpViewController
            popUpViewController.modalPresentationStyle = .overCurrentContext
            presentingViewController.present(popUpViewController, animated: false, completion: nil)
        }
    }
}
