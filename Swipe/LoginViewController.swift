//
//  LoginViewController.swift
//  Swipe
//
//  Created by Brett Wallace on 8/12/15.
//  Copyright (c) 2015 Brett Wallace. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedFBLogin(sender: UIButton) {
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: { (user, error) -> Void in
            if user == nil {
                println("The user canceled the Facebook login")
            } else if user!.isNew {
                println("User signed up and logged in thru Facebook")
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture, first_name, birthday, gender", completionHandler: {
                    connection, result, error in
                        var r = result as! NSDictionary
                        user!["firstName"] = r["first_name"]
                        user!["gender"] = r["gender"]
                        user!["picture"] = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"]
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        user!["birthday"] = dateFormatter.dateFromString(r["birthday"] as! String)
                    
                    user!.saveInBackgroundWithBlock({
                        success, error in
                            println(success)
                            println(error)
                    })
                })
            } else {
                println("User logged in thru Facebook")
            }
        })
    }
}
