//
//  RegisterViewController.swift
//  MeetEmApp
//
//  Created by Abel Tsegaye on 6/8/19.
//  Copyright © 2019 Abel Tsegaye. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBAction func registerPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.showError(withStatus: "please enter a valid Email and password with min 6 characters")
            } else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "toSelection", sender: self)
            }
        }
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
