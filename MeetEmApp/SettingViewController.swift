//
//  SettingViewController.swift
//  MeetEmApp
//
//  Created by Abel Tsegaye on 6/8/19.
//  Copyright © 2019 Abel Tsegaye. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    
    @IBOutlet weak var userLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLable.text = Auth.auth().currentUser!.email
        // Do any additional setup after loading the view.
    }

    @IBAction func logOutPressed(_ sender: Any) {
        SVProgressHUD.show()
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
            SVProgressHUD.showError(withStatus: "Sign Out failed")
        }
        SVProgressHUD.dismiss()
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
        //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
       // storyBoard.instantiateInitialViewController()
        //storyboard!.instantiateViewController(withIdentifier: "firstNavigationController") as! UINavigationController
        
//        if let storyboard = self.storyboard {
//            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! UINavigationController
//            self.present(vc, animated: false, completion: nil)
//        }
//    }
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
