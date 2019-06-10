//
//  LoginViewController.swift
//  MeetEmApp
//
//  Created by Abel Tsegaye on 6/8/19.
//  Copyright © 2019 Abel Tsegaye. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailtext: UITextField!
    
    
    @IBOutlet weak var passwordtext: UITextField!
    
    
    @IBAction func loginPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailtext.text!, password: passwordtext.text!) { (user, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.showError(withStatus: "Incorrect Email or password")
                
            }else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "toSelection", sender: self)
            }
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
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
