//
//  MainMenuViewController.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 17/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import UIKit
import SimpleImageViewer
import PKHUD

class MainMenuViewController: UIViewController {
    
    var netView = UIView()
    
    @IBOutlet weak var navBarViewHeight: NSLayoutConstraint?
    @IBOutlet weak var navBarView: UIView?
    @IBOutlet weak var menuLeftButton: UIButton?
    @IBOutlet weak var menuRightButton: UIButton?
    
    @IBOutlet weak var bgView: UIView?
    
    @IBOutlet weak var tabView: UIView?
    @IBOutlet weak var tabHideKeyBoardView: UIView?
    
    @IBOutlet weak var topLabel: UILabel?
    
    
    @IBOutlet weak var showImageView: UIImageView!
   
    
    override func viewDidDisappear(_ animated: Bool) {
        dismissKeyboard()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView?.YSDDropShadow()
        navBarView?.backgroundColor = AppGlobal.design.getColor(.main)
        self.view.backgroundColor = AppGlobal.design.getColor(.main)

        topLabel?.YSDSet(size: 16, color: .white ,style: .bold)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.tabView?.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap2.cancelsTouchesInView = false
        self.tabHideKeyBoardView?.addGestureRecognizer(tap2)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        let image = UIImageView(frame: CGRect(x: (AppGlobal.design.screenSize.width / 2) - 5 , y:(AppGlobal.design.screenSize.height / 2) - 5 , width: 10,  height:10))
        image.image = UIImage(named: "no-image")
        self.view.addSubview(image)
        image.alpha = 0
        showImageView = image
    }
    
    func showImage(_ image: UIImage? = nil) {
        if let _image = image {
            showImageView.image = _image
        }
        let configuration = ImageViewerConfiguration { config in
            config.imageView = showImageView
        }
        self.present(ImageViewerController(configuration: configuration), animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
//    }
//    
    
    
    @IBAction func closeNetViewButtonPress(_ sender: Any) { 
    }
    
    func showNetView(_ isShow: Bool){
            UIView.animate(withDuration: 0.2, animations: { [weak self]() -> Void in
                if isShow {
                    self?.netView.alpha = 1
                } else {
                    self?.netView.alpha = 0
                }
                self?.view.layoutIfNeeded()
            })
    }
    
    
    @IBAction func menuLeftButtonPress(_ sender: UIButton) { 
        self.dismissKeyboard()
        didMenuLeftButtonPress() }
    @IBAction func menuRightButtonPress(_ sender: UIButton) { 
        self.dismissKeyboard()
        didMenuRightButtonPress()}
    
    func didMenuLeftButtonPress(){
        dismissOrPop()
    }
    
    func didMenuRightButtonPress(){
        print("didDetailRightButtonPress")
    }
    
    func backPrevious(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func didkeyboardWillShow(){}
    func didkeyboardWillHide(){}
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size.height = UIScreen.main.bounds.size.height - keyboardSize.height
            UIView.animate(withDuration: 0.2, animations: { [weak self]() -> Void in
                self?.didkeyboardWillShow()
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.size.height = UIScreen.main.bounds.size.height
        UIView.animate(withDuration: 0.2, animations: { [weak self]() -> Void in
            self?.didkeyboardWillHide()
            self?.view.layoutIfNeeded()
        })
    }
    
    
    
    
    
}

extension MainMenuViewController {
    
}
