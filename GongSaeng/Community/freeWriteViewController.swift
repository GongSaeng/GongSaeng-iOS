//
//  freeWriteViewController.swift
//  community
//
//  Created by 유경민 on 2021/12/28.
//

import UIKit

class freeWriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var contentsField: UITextView!
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        let titleText = titleField.text ?? "test title"
        let contentsText = contentsField.text ?? "test contents"
        freeNetwork.freeWrite(titleText: titleText, contentsText: contentsText)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backward(_ sender: UIButton) {
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
