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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
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

    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
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
