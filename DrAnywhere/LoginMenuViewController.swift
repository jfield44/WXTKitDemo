//
//  LoginMenuViewController.swift
//  DrAnywhere
//
//  Created by Jonathan Field on 20/05/2017.
//  Copyright © 2017 Cisco. All rights reserved.
//

import UIKit

class LoginMenuViewController: UIViewController, LoginCoordinatorDelegate {
    
    lazy var loginCoordinator: LoginCoordinator = {
        let lvc = LoginCoordinator(rootViewController: self)
        lvc.delegate = self
        return lvc
    }()
    
    func didLogIn() {
        print("Hello")
        self.loginCoordinator.finish()
        self.performSegue(withIdentifier: "toDoctorList", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginCoordinator.start()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
