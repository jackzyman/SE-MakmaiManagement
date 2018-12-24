//
//  LoginViewController.swift
//  JongYa
//
//  Created by Jarukit Rungruang Punkaew on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//



import UIKit
import FacebookCore
import FacebookLogin
import GRDB

class LoginViewController: MainLoginViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleTextLabel: UILabel!
    
    var titleText = "กรุณาใส่อีเมลของคุณ"
    
    // facebook
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.backgroundColor = .white

        secondaryBT?.backgroundColor = AppGlobal.design.getColor(.facebook)
        
        mainBT?.YSDSetMain(false)
        titleTextLabel.text = titleText
        titleTextLabel.textColor = AppGlobal.design.getColor(.main)
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0 - (keyboardSize.height - 80)
            UIView.animate(withDuration: 0.2, animations: { [weak self]() -> Void in
                self?.didkeyboardWillShow()
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self]() -> Void in
            self?.didkeyboardWillHide()
            self?.view.layoutIfNeeded()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMainButtonPress() {
//        let user = UserInfo(name: self.emailTextField.text!, role: 1, email: self.emailTextField.text!)
        self.checkUser(name: self.emailTextField.text!, email: self.emailTextField.text!)
//        self.gotomaintab(user)
        
    }
    
    func gotomaintab(_ userInfo: UserInfo){
        AppGlobal.load.waiting()
        AppGlobal.storage.login(userInfo)
        AppGlobal.load.done()
        AppGlobal.shared.appDelegate.createMenuView()
    }
    override func didSecondaryButtonPress() {
        internalFacebookLogin()
    }
    
    @IBAction func emailTextFieldDidChange(_ sender: UITextField) {
        mainBT?.YSDSetMain(emailTextField.YSDCheckState(.email, setDanger: false))
    }
    
    fileprivate func internalFacebookLogin() {
        loginManager.logIn(readPermissions: [ .publicProfile, .email/*, .userFriends*/ ], viewController: self) { [weak self] loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_ ,_ , let accessToken):
                print("Logged in!")
                print(accessToken.authenticationToken)
                
                
                let connection = GraphRequestConnection()
                connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id,email,name"])) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        print("Custom Graph Request Succeeded: \(response)")
//                        let fbid = response.dictionaryValue?["id"] as! String
//                        let imgUrl = "https://graph.facebook.com/\(fbid)/picture?type=large&return_ssl_resources=1"
                        let email = response.dictionaryValue?["email"] as? String ?? nil
                        let userName =  response.dictionaryValue?["name"] as? String ?? ""
                        
                        self?.checkUser(name: userName, email: email ?? userName)

                        
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
            }
        }
    }
    
    public func checkUser(name: String, email: String) {
        try! appDatabase.inDatabase { db in
            if let user1 = try UserDB.filter(Column("name").like(name)).fetchOne(db) {
                self.gotomaintab(user1.toMappable())
            } else if let user2 = try UserDB.filter(Column("email").like(email)).fetchOne(db){
                self.gotomaintab(user2.toMappable())
            } else {
                let newUser = UserDB(name: name, role: 0, email: email)
                try newUser.insert(db)
                self.gotomaintab(newUser.toMappable())
            }
        }
    }
}


