//
//  MainTableViewController.swift
//  Fisherman
//
//  Created by Jarukit Rungruang on 21/1/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit

class MainTableViewController: MainMenuViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var topRefreshControl: UIRefreshControl!
    
    var numberOfRowsInSection = 0
    var numberOfSections = 1
    var heightForHeaderInSection : CGFloat = 0.01
    var heightForFooterInSection  : CGFloat = 0.01
    
    @IBOutlet weak var  emptryLabel: UILabel?
    var callChooseWWCalendar : ((Date) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = AppGlobal.design.getColor(.white)
        tableView.showsVerticalScrollIndicator = false
//        tableView.separatorStyle = .none
      
        //        let label = UILabel(frame: CGRect(x: tableView.frame.minX , y:  tableView.frame.maxY + (tableView.frame.size.height/2), width: tableView.frame.size.width,  height:40))
        //        label.text = "กำลังโหลดข้อมูล"
        //        label.textColor = .lightGray
        //        label.font = UIFont.boldSystemFont(ofSize: 16)
        ////        label.center = tableView.center
        //        emptryLabel = label
        //        view.addSubview(label)
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadContent() 
        
    }
    
    func setEmptryLabel (_ count : Int, text: String = "ไม่มีข้อมูล"){
        if count == 0 {
            self.emptryLabel?.isHidden = false
            self.emptryLabel?.text = text
        } else {
            self.emptryLabel?.isHidden = true
        }
    }
    
    func addTopRefresh(){
        topRefreshControl = UIRefreshControl()
        topRefreshControl.addTarget(self, action: #selector(self.topRefresh(_:)), for: .valueChanged)
        tableView.addSubview(topRefreshControl)
    }
    
    @objc private func topRefresh(_ sender:AnyObject) {
        reloadContent()
    }
    
    func reloadContent(){
        
        
    }
}

extension MainTableViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection      
    }
}

