//
//  CompletedRegisterViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/05/29.
//

import UIKit

class CompletedRegisterViewController: UIViewController {

    var user: User?
    let viewModel: UserViewModel = UserViewModel()
    
    @IBOutlet weak var triangleButton: UIButton!
    @IBOutlet weak var orageView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let registerUser = user else { return }
        viewModel.addUser(registerUser)
        prepareAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    private func prepareAnimation() {
        orageView.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        triangleButton.transform = CGAffineTransform(scaleX: 3, y: 3)
    }
    
    private func showAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: .allowAnimatedContent, animations: {
            self.orageView.transform = CGAffineTransform.identity
            self.triangleButton.transform = CGAffineTransform.identity
        }, completion: nil)

        UIView.transition(with: triangleButton, duration: 1.0, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    @IBAction func goFirst(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

