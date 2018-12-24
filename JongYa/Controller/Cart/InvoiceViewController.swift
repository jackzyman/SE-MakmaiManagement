//
//  InvoiceViewController.swift
//  JongYa
//
//  Created by MosAC on 5/12/2561 BE.
//  Copyright © 2561 Jarukit Rungruang. All rights reserved.
//

import UIKit
import GRDB

class InvoiceViewController: MainTableViewController {
    //    @IBOutlet weak var dateLabel: UILabel!
    //    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var tableView2: UITableView!
    var content : [CartItem] = []
    var totalPrice : Int = 0
    var trannumber = ""
    
    @IBOutlet weak var imageSaveHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView2.isHidden = true
        tableView2.dataSource = self
        tableView2.delegate = self
        tableView2.estimatedRowHeight = 40
        tableView2.rowHeight = UITableView.automaticDimension
        tableView2.backgroundColor = .white
        
        save.YSDSetMain()
        content = AppGlobal.storage.getCart().items
        let now = Date()
        trannumber = "T\(now.mpTranIDDate())"
        //numberOfRowsInSection = AppGlobal.storage.getCart().items.count
        //getCurrentDateTime()
        
        numberOfSections = 2
        imageSaveHeight.constant = 110 + 40 + ( 31 * CGFloat(content.count) ) + 30
        
        for i in 0...content.count - 1 {
            totalPrice = totalPrice + content[i].totalPrice()
        }
        
        insertOrder()
        
    }
    
    override func reloadContent() {
        content = AppGlobal.storage.getCart().items
        
        numberOfRowsInSection = AppGlobal.storage.getCart().items.count
        self.tableView.reloadData()
    }
    
    
    
    
    func insertOrder(){
        try! appDatabase.inDatabase { db in
            let newinvoie = InvoieDB(id: trannumber, userId: AppGlobal.storage.getUser()!.id, 
                                     date: Date().toServerString(),
                                     enddate: Date().addingTimeInterval(60*60*4).toServerString(), 
                                     priceTotal: totalPrice)
            try newinvoie.insert(db)
            for i in 0...content.count - 1 {
                let cartItem = content[i]
                let neworder = OrderDB(productId: cartItem.drug.id , invoiceId: trannumber, amount: cartItem.amount)
                try neworder.insert(db)
                
                let drug = cartItem.drug.toDB()
                try db.execute(
                    "UPDATE drug SET stock = :stock WHERE id = :id",
                    arguments: ["stock": drug.stock - cartItem.amount, "id": drug.id])
            }
        }
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        tableView2.isHidden = true
        AppGlobal.storage.resetCart()
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "ผิดพลาด", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: { (_) in
                AppGlobal.shared.appDelegate.createMenuView()
            }))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "สำเร็จ", message: "บันทึกรูปภาพใบสั่งซื้อลงคลังภาพเรียบร้อย", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                AppGlobal.shared.appDelegate.createMenuView()
            }))
            present(ac, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00001
        } else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return content.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InvoiceTableViewCell
        
        cell.titleInvoiceLabel.text = "รายการ"
        cell.priceInvoiceLabel.text = "ราคา"
        cell.amountInvoiceLabel.text = "จำนวน"
        cell.sumInvoiceLabel.text =  "ราคารวม"
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! InvoiceTableViewCell
            let item = content[indexPath.row]
            
            cell.titleInvoiceLabel.text = (indexPath.row + 1).mpCMNumber() + ". " + item.drug.name
            cell.priceInvoiceLabel.text = item.drug.price.mpCMNumber()
            cell.amountInvoiceLabel.text = item.amount.mpCMNumber()
            cell.sumInvoiceLabel.text = (item.amount * item.drug.price).mpCMNumber() + " ฿"
            
            //totalPrice += (item.amount * item.drug.price)/2
            //let xNSNumber = totalPrice as NSNumber // เปลี่ยน type totalPrice จาก int to String
            //totalPriceLabel.text = "ราคาทั้งหมด " + totalPrice.mpCMNumber() + "บาท"
            return cell
            
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell2", for:indexPath) as! InvoiceTitleTableViewCell
            
            cell.emailLabel.text = "\(trannumber)" 
            cell.dateLabel.text = (AppGlobal.storage.getUser()?.name)! 
            cell.numberLabel.text = Date().mpShotDate()
            cell.sumInvoiceLabel.text = totalPrice.mpCMNumber() + "฿"
            cell.topicLabel.text = "ใบสั่งซื้อ"
            return cell
        }
    }
    
    @IBAction func actionSaveScreenShot(_ sender: Any) {
        tableView2.isHidden = false
        //save รูปลงเครื่อง
        if let image:UIImage = self.tableView2.mpRenderPNG() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
    }
    
    //    func getCurrentDateTime(){
    //        // ฟังก์ชันโชว์วันที่และเวลา
    //        let formatter = DateFormatter()
    ////        formatter.dateStyle = .long
    ////        formatter.timeStyle = .medium
    //        formatter.dateFormat = "EEEE, dd MMMM yyyy HH:mm a" // จัดformatว่าอยากโชว์อะไรบ้าง
    //        let stringDate = formatter.string(from: Date())
    //        dateLabel.text = stringDate
    //    }
}

class InvoiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amountInvoiceLabel: UILabel!
    @IBOutlet weak var titleInvoiceLabel: UILabel!
    @IBOutlet weak var priceInvoiceLabel: UILabel!
    @IBOutlet weak var sumInvoiceLabel: UILabel!
    
}

class InvoiceTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sumInvoiceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
}
