//
//  MainLoginViewController.swift
//  Saparnpla
//
//  Created by Jarukit Rungruang on 21/1/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit

class MainLoginViewController: MainMenuViewController {
    
    @IBOutlet weak var titleNavBarLabel: UILabel?
    
    @IBOutlet weak var mainBT : UIButton?
    @IBAction func mainButtonPress(_ sender: UIButton) { 
        self.dismissKeyboard()
        didMainButtonPress() }
    func didMainButtonPress() {}
    
    @IBOutlet weak var secondaryBT : UIButton?
    @IBAction func secondaryButtonPress(_ sender: UIButton) { 
        self.dismissKeyboard()
        didSecondaryButtonPress() }
    func didSecondaryButtonPress() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavBarLabel?.YSDSet(size: 17, color: .white, style: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
