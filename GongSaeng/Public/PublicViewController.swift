//
//  PublicViewController.swift
//  GongSaeng
//
//  Created by 조영우 on 2021/06/13.
//

import UIKit

class PublicViewController: UIViewController {
    //----------------------------------------------------------------
    // MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var immediationButton: UIButton!
    @IBOutlet weak var reservationButton: UIButton!
    @IBOutlet weak var immediationButtonUnderlinedView: UIView!
    @IBOutlet weak var reservationButtonUnderlinedView: UIView!
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //----------------------------------------------------------------
    // MARK:- Abstract Method
    static func viewController() -> PublicViewController {
        return UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "PublicViewController") as! PublicViewController
    }

    //----------------------------------------------------------------
    // MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //----------------------------------------------------------------
    // MARK:- Variables
    private lazy var immediationViewController: ImmediationViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Public", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ImmediationViewController") as! ImmediationViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        return viewController
    }()

   private lazy var reservationViewController: ReservationViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Public", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        return viewController
   }()

    //----------------------------------------------------------------
    // MARK:- Action Methods
    @IBAction func immediationButtonTapped(_ sender: UIButton) {
        buttonTapped(sender)
    }
    
    @IBAction func reservationButtonTapped(_ sender: UIButton) {
        buttonTapped(sender)
    }
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        self.addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func buttonTapped(_ button: UIButton) {
        [immediationButton, reservationButton].forEach {
            if $0 == button {
                $0?.isSelected = true
                $0?.isEnabled = false
                $0?.setTitleColor(UIColor(white: 0, alpha: 0.87), for: .normal)
            } else {
                $0?.isSelected = false
                $0?.isEnabled = true
                $0?.setTitleColor(UIColor(white: 0, alpha: 0.30), for: .normal)
            }
        }
        
        if button == immediationButton {
            immediationButtonUnderlinedView.isHidden = false
            reservationButtonUnderlinedView.isHidden = true
        } else {
            immediationButtonUnderlinedView.isHidden = true
            reservationButtonUnderlinedView.isHidden = false
        }
        
        updateView()
    }
    
    private func setupButton() {
        buttonTapped(immediationButton)
    }

    private func updateView() {
        if immediationButton.isSelected {
            remove(asChildViewController: reservationViewController)
            add(asChildViewController: immediationViewController)
        } else {
            remove(asChildViewController: immediationViewController)
            add(asChildViewController: reservationViewController)
        }
    }

    func setupView() {
        updateView()
    }
}
