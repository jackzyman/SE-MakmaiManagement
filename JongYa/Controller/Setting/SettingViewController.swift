//
//  SettingViewController.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 30/10/18.
//  Copyright © 2561 Jarukit Rungruang. All rights reserved.
//

import UIKit

class SettingViewController: MainTableViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    let user = ["ตะกร้าสินค้า", "รายการสั่งซื้อ", "ออกจากระบบ"]
    let admin = ["เพิ่มสินค้า" , "ลบ/ แก้ไข/ จัดการสินค้า", "รายการสั่งซื้อ", "ออกจากระบบ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.textColor = AppGlobal.design.getColor(.main)
        usernameLabel.text = AppGlobal.storage.getUser()?.name
        tableView.backgroundColor = UIColor.groupTableViewBackground
        
//        if AppGlobal.storage.getUser()?.role == 1 { //admin = 1
//            numberOfSections = 2
//        } else {
            numberOfSections = 1
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppGlobal.db.checkInvoieDBStatus()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppGlobal.storage.getUser()?.role == 0 {
            return user.count
        } else {
            return admin.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if AppGlobal.storage.getUser()?.role == 0 {
            return 10
        } else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! MenuProfileTableViewCell
        if AppGlobal.storage.getUser()?.role == 0 {
            cell.titleLabel.text = user[indexPath.row]
            cell.imageIcon.image = UIImage(named: "ic_u\(indexPath.row)")
        } else {
            cell.titleLabel.text = admin[indexPath.row]
            cell.imageIcon.image = UIImage(named: "ic_a\(indexPath.row)")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppGlobal.storage.getUser()?.role == 0 {
            if indexPath.row == 0 {
                let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                AppGlobal.navigationController?.pushViewController(view, animated: true)
            } else if indexPath.row == 1 {
                let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "OrderListViewController") as! OrderListViewController
                AppGlobal.navigationController?.pushViewController(view, animated: true)
                
            } else if indexPath.row == 2 {
            self.YSDShowAlertCancel("ออกจากระบบ", message: "คุณยืนยันการออกจากระบบหรือไม่", action: "ยืนยัน", canceltext: "ยกเลิก", submit: {
                AppGlobal.storage.resetCart()
                AppGlobal.storage.logout()
                AppGlobal.shared.appDelegate.createLoginView()
                }, cancel: {})
            }
        } else {
            if indexPath.row == 0 {
                let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
                AppGlobal.navigationController?.pushViewController(view, animated: true)
            } else if indexPath.row == 1 {
                let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "AdminProductViewController") as! AdminProductViewController
                AppGlobal.navigationController?.pushViewController(view, animated: true)
            } else if indexPath.row == 2 {
                let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "AdminOrderListViewController") as! AdminOrderListViewController
                AppGlobal.navigationController?.pushViewController(view, animated: true)
            } else if indexPath.row == 3 {
                self.YSDShowAlertCancel("ออกจากระบบ", message: "คุณยืนยันการออกจากระบบหรือไม่", action: "ยืนยัน", canceltext: "ยกเลิก", submit: {
                    AppGlobal.storage.resetCart()
                    AppGlobal.storage.logout()
                    AppGlobal.shared.appDelegate.createLoginView()
                }, cancel: {})
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if AppGlobal.storage.getUser()?.role == 1 {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "header") as! HeaderTableViewCell
            cell.titleLabel.text = "สำหรับแอดมิน"
            
            return cell
        } else {
            return nil
        }
        
    }
}



class MenuProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel! 
    @IBOutlet weak var imageIcon: UIImageView! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel! 
    @IBOutlet weak var detailLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
