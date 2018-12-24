//
//  OrderDetailListViewController.swift
//  JongYa
//
//  Created by Methawee Punkaew on 22/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit
import GRDB

class OrderDetailListViewController: MainTableViewController {

    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var tableView2: UITableView!
    
    var invoice : InvoieDB!
    var content : [CartItem] = []
    var isExpied = false
    
    @IBOutlet weak var imageSaveHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView2.isHidden = true
        tableView2.dataSource = self
        tableView2.delegate = self
        tableView2.estimatedRowHeight = 40
        tableView2.rowHeight = UITableView.automaticDimension
        tableView2.backgroundColor = .white
        
        
        if OrderStatus(rawValue: invoice.status) == OrderStatus.watting {
            save.YSDSetMain(true)
        } else if OrderStatus(rawValue: invoice.status) == OrderStatus.expire {
            save.YSDSetMain(true)
            isExpied = true
            topLabel?.text = "รายการหมดอายุแล้ว"
            save.setTitle("สั่งสินค้าใหม่อีกครั้ง" , for: .normal)
        } else {
            save.setTitle("รายการ" + OrderStatus(rawValue: invoice.status)!.description , for: .normal)
        }
        
        try! appDatabase.inDatabase { db in
            let orders =  try OrderDB.filter(Column("invoiceId").like(invoice.id)).fetchAll(db) 
            if orders.count > 0 {
                for i in 0...orders.count - 1 {
                    if let product = try DrugDB.filter(Column("id").like(orders[i].productId)).fetchOne(db) {
                        let item = CartItem(drug: product.toMappable(), amount: orders[i].amount)
                        content.append(item)
                        self.tableView.reloadData()
                    }
                    
                    
                }
            }
            imageSaveHeight.constant = 110 + 40 + ( 31 * CGFloat(content.count) ) + 30
        }
        
        numberOfSections = 2
        
    
        
    }
   
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        tableView2.isHidden = true

        
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "ผิดพลาด", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ตกลง", style: .default, handler: { (_) in
                
            }))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "สำเร็จ", message: "บันทึกรูปภาพใบสั่งซื้อลงคลังภาพเรียบร้อย", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                
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
            
            return cell
            
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell2", for:indexPath) as! InvoiceTitleTableViewCell
            
            cell.emailLabel.text = invoice.id
            cell.dateLabel.text = (AppGlobal.storage.getUser()?.name)! 
            cell.numberLabel.text = invoice.date.mpToDate().mpShotDate()
            cell.sumInvoiceLabel.text = invoice.priceTotal.mpCMNumber() + "฿"
            cell.topicLabel.text = "ใบสั่งซื้อ"
            return cell
        }
    }
    
    @IBAction func actionSaveScreenShot(_ sender: Any) {
        if isExpied {
            self.YSDShowAlertCancel("ยืนยันการสั่งสินค้าอีกครั้ง", message: "คุณยืนยันว่าจะทำรายการสั่งซื้อนี้อีกครั้งหรือไม่", action: "ยืนยัน", canceltext: "ยกเลิก", submit: {
                try! appDatabase.inDatabase { db in
                    var isCanToBuy = true
                    for i in 0...self.content.count - 1 {
                        if let drug = try DrugDB.filter(Column("id").like(self.content[i].drug.id)).fetchOne(db) {
                            if drug.stock < self.content[i].amount {
                                isCanToBuy = false
                                self.YSDShowAlertOK("ผิดพลาด", message: "ขออภัย มีสินค้าในคลังไม่เพียงพอต่อรายการสั่งซื้อของคุณ ไม่สามารถทำรายการซ้ำได้", action: "ตกลง") {
                                    return
                                }
                            } 
                        } else {
                            isCanToBuy = false
                            self.YSDShowAlertOK("ผิดพลาด", message: "ขออภัย ไม่สามารถทำรายการซ้ำได้เนื่องจากสินค้าได้ถูกลบ หรือเหตุขัดข้องบางประการ", action: "ตกลง") {
                                return
                            }
                        }
                    }
                    if isCanToBuy {
                        
                        try InvoieDB.filter(Column("id").like(self.invoice.id)).deleteAll(db)
                        
                        let newinvoie = InvoieDB(id: self.invoice.id, userId: AppGlobal.storage.getUser()!.id, 
                                                 date: Date().toServerString(),
                                                 enddate: Date().addingTimeInterval(60*60*4).toServerString(), 
                                                 priceTotal: self.invoice.priceTotal)
                        try newinvoie.insert(db)
                        for i in 0...self.content.count - 1 {
                            let cartItem = self.content[i]
                            let drug = cartItem.drug.toDB()
                            try db.execute(
                                "UPDATE drug SET stock = :stock WHERE id = :id",
                                arguments: ["stock": drug.stock - cartItem.amount, "id": drug.id])
                        }
                        
                        self.dismissOrPop()
                    }
                }
            }, cancel: {})
        } else {
            tableView2.isHidden = false
            //save รูปลงเครื่อง
            if let image:UIImage = self.tableView2.mpRenderPNG() {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
        
    }
    
}
