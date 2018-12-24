//
//  AdminProductViewController.swift
//  JongYa
//
//  Created by Methawee Punkaew on 22/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit
import Kingfisher
import GRDB

class AdminProductViewController: MainTableViewController{
    
    @IBOutlet weak var searhTextField: UITextField!
    var content : [DrugDB] = []
    
    override func viewWillAppear(_ animated: Bool) {
        selectDrugDatabase()
    }
    
    @IBAction func searchFieldTextEditing(_ sender: UITextField) {
        selectDrugDatabase(sender.text ?? "")
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        addTopRefresh()
        
    }
    override func reloadContent() {
        selectDrugDatabase()
    }
    
    func selectDrugDatabase(_ text: String = ""){
        try! appDatabase.inDatabase { db in
            self.content =  try DrugDB.filter(Column("name").like("%\(text)%")).order(Column("date").desc).fetchAll(db) 
            self.topRefreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func selectDrugCode(_ code: String = ""){
        try! appDatabase.inDatabase { db in
            if let item = try DrugDB.filter(Column("id").like("%\(code)%")).fetchOne(db) {
                let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
                view.currentDrug = item
                AppGlobal.navigationController?.pushViewController(view, animated: true)
            } else {
                self.YSDShowAlertCancel("ไม่พบสินค้าในคลัง", message: "ไม่พบสินค้า id \(code) ต้องการเพิ่มสินค้าใหม่หรือไม่?", action: "เพิ่มสินค้านี้", canceltext: "ปิด", submit: {
                    let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
                    view.addNewId = code
                    AppGlobal.navigationController?.pushViewController(view, animated: true)
                }, cancel: {})
            }
        }
    }
    
    @IBAction func didScanButtonPress(_ sender: Any) {
        let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        view.callCode = { code in
            self.selectDrugCode(code)
        }
        self.present(view, animated: true, completion: nil)
    }
    
    override func didMenuRightButtonPress() {
        let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        AppGlobal.navigationController?.pushViewController(view, animated: true)
    }
    
}


extension AdminProductViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        view.currentDrug = content[indexPath.row]
        AppGlobal.navigationController?.pushViewController(view, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CartTableViewCell
        
        let item = content[indexPath.row]
        if let url = URL(string: item.image) {
            cell.contentImageView.kf.setImage(with: url)
        } else if let data = NSData(base64Encoded: item.image, options: .ignoreUnknownCharacters){
            cell.contentImageView.image = UIImage(data: data as Data)
        } else {
            cell.contentImageView.image = AppGlobal.design.noImage
        }
        
        cell.isShow = item.active
        cell.didhide = { isShow in
            try! appDatabase.inDatabase { db in
                if isShow {
                    try db.execute(
                        "UPDATE drug SET active = :active WHERE id = :id",
                        arguments: ["active": 1, "id": item.id])
                    self.content[indexPath.row].active = true
                } else {
                    try db.execute(
                        "UPDATE drug SET active = :active WHERE id = :id",
                        arguments: ["active": 0, "id": item.id])
                    self.content[indexPath.row].active = false
                }
            }
        }
        
        
        cell.idLabel.text = item.id
        cell.titleLabel.text = item.name
        cell.priceLabel.text = " ฿" + item.price.mpCMNumber() + " "
        cell.amoutLabel.text = "ขายได้ : " + item.sold.mpCMNumber()
        cell.sumLabel.text = "คงเหลือ : " + item.stock.mpCMNumber()
        cell.didDeleteItem = {  
            self.YSDShowAlertCancel("ยืนยันการลบสินค้า", message: "คุณยืนยันการลบสินค้านี้ออกจากคลังสินค้า", action: "ยืนยัน", canceltext: "ยกเลิก", submit: {
                let temp = self.content[indexPath.row]
                self.content.remove(at: indexPath.row)
                self.deleteDrug(temp)
                
            }, cancel: {})
        }
        return cell
    }
    
    func deleteDrug(_ drug: DrugDB){
        try! appDatabase.inDatabase { db in
            try DrugDB.filter(Column("id").like(drug.id)).deleteAll(db)
            self.tableView.reloadData()
        }
    }
    
}



