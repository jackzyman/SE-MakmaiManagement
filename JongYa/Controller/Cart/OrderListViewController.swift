//
//  OrderListViewController.swift
//  JongYa
//
//  Created by Methawee Punkaew on 22/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit
import GRDB

class OrderListViewController: MainTableViewController {
    
    var content : [InvoieDB] = [] {
        didSet {
            var allcontent: [[InvoieDB]] = [[]] 
            if content.count > 0 {
                var currentDay = content[0].date.mpToDate().mpDayInt()
                var currentMonth = content[0].date.mpToDate().mpMonthInt()
                
                for i in 0...content.count - 1 {
                    let date = content[i].date.mpToDate() 
                        let day = date.mpDayInt()
                        let month = date.mpMonthInt()
                        
                        
                        if day == currentDay && month == currentMonth {
                            allcontent[allcontent.count - 1].append(content[i])
                        } else {
                            currentDay = day
                            currentMonth = month
                            allcontent.append([])
                            allcontent[allcontent.count - 1].append(content[i])
                        }
                    
                }
                self.allcontent = allcontent
            } else {
                allcontent = []
            }
        }
    }
    
    var allcontent: [[InvoieDB]] = [] {
        didSet {
            self.tableView.reloadData()
            self.emptryLabel?.isHidden = content.count > 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopRefresh()
        reloadContent()
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppGlobal.db.checkInvoieDBStatus()
        reloadContent()
    }
    
    
    override func reloadContent() {
        
        AppGlobal.db.checkInvoieDBStatus()
        
        try! appDatabase.inDatabase { db in
            content = try InvoieDB.filter(Column("userId").like(AppGlobal.storage.getUser()!.id)).order(Column("date").desc).fetchAll(db) 
            self.topRefreshControl.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if allcontent[section].count > 0 {
            return 40
        } else {
            return 0.000000001
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allcontent.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allcontent[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let item = allcontent[section][0]
            let cell  = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderTableViewCell
            cell.titleLabel.text = item.date.mpToDate().mpThaiDate()
//            var total = 0
//            for i in 0...allcontent[section].count - 1 {
//                let data = allcontent[section][i]
//                if data.status == 0 || data.status == 2 {
//                    total = total + data.priceTotal
//                }
//            }
            cell.detailLabel?.text = nil
            return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "OrderDetailListViewController") as! OrderDetailListViewController
        view.invoice = allcontent[indexPath.section][indexPath.row]
        AppGlobal.navigationController?.pushViewController(view, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell2", for:indexPath) as! OrderListTableViewCell
        let item = allcontent[indexPath.section][indexPath.row]
        
        cell.idLabel.text = "\(indexPath.row + 1). " + item.id
        cell.dateLabel.text = item.date.mpToDate().mpShotDate() + " " + item.date.mpToDate().mpTimeOnly() + " (" + item.enddate.mpToDate().mpTimeLeft().0 + ")"
        cell.sumLabel.text =  item.priceTotal.mpCMNumber() + "฿"
        cell.statusLabel.text = OrderStatus(rawValue: item.status)?.description
        cell.statusImageView.image = OrderStatus(rawValue: item.status)?.image
        cell.statusLabel.textColor = OrderStatus(rawValue: item.status)?.color
        return cell
    }
    
}


class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
}


public enum OrderStatus: Int, CustomStringConvertible {
    case watting = 0
    case expire = 1
    case success = 2
    
    public var description: String {
        switch self {
        case .watting: return "กำลังดำเนินการ"
        case .expire: return "หมดอายุ"
        case .success: return "เสร็จสิ้น"
        }
    }
    
    public var color: UIColor {
        switch self {
        case .watting: return UIColor("#FFB655")
        case .expire: return UIColor("#FE6663")
        case .success: return UIColor("#69DE5A")
        }
    }
    
    public var image: UIImage? {
        switch self {
        case .watting: return UIImage(named: "ic_status_0")
        case .expire: return UIImage(named: "ic_status_1")
        case .success: return UIImage(named: "ic_status_2")
        }
    }
}
