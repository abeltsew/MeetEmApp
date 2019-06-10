//
//  WelcomeViewController.swift
//  MeetEmApp
//
//  Created by Abel Tsegaye on 6/8/19.
//  Copyright © 2019 Abel Tsegaye. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    @IBAction func loginPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogIn", sender: self)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goHome", sender: self)
        }
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
