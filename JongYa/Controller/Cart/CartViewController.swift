//
//  CartViewController.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 31/10/18.
//  Copyright © 2561 Jarukit Rungruang. All rights reserved.
//

import UIKit

class CartViewController: MainTableViewController {
    
    
    @IBOutlet weak var jongButton: UIButton!
    var content : [CartItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel?.text = "ตะกร้า"
        content = AppGlobal.storage.getCart().items
        jongButton.YSDSetMain(AppGlobal.storage.getCart().items.count > 0)
        numberOfRowsInSection = AppGlobal.storage.getCart().items.count
    }

    override func reloadContent() {
        content = AppGlobal.storage.getCart().items
        jongButton.YSDSetMain(AppGlobal.storage.getCart().items.count > 0) //  กดได้ก็ต่อเมื่อมีของในรถเข็น
        numberOfRowsInSection = AppGlobal.storage.getCart().items.count
        self.emptryLabel?.isHidden = content.count > 0 
        self.tableView.reloadData()
    }
    
    override func didMenuRightButtonPress() {
        if content.count > 0 {
        self.YSDShowAlertCancel("ยืนยันการลบสินค้าทั้งหมด", message: "คุณยืนยันการลบสินค้าทั้งหมดออกจากตะกร้าหรือไม่", action: "ยืนยัน", canceltext: "ยกเลิก", submit: {
            AppGlobal.storage.resetCart()
            self.reloadContent()
        }, cancel: {})
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! CartTableViewCell
        let item = content[indexPath.row]
        
        
        if let url = URL(string: item.drug.image) {
            cell.contentImageView.kf.setImage(with: url)
        } else if let data = NSData(base64Encoded: item.drug.image, options: .ignoreUnknownCharacters){
            cell.contentImageView.image = UIImage(data: data as Data)
        } else {
            cell.contentImageView.image = AppGlobal.design.noImage
        }
        cell.idLabel.text = item.drug.id
        cell.titleLabel.text = item.drug.name
        cell.priceLabel.text = " ฿" + item.drug.price.mpCMNumber() + " "
        cell.amoutLabel.text = "จำนวน : " + item.amount.mpCMNumber()
        cell.sumLabel.text = "ราคารวม : " + (item.amount * item.drug.price).mpCMNumber() + " บาท"
        cell.didDeleteItem = {  
            self.YSDShowAlertCancel("ยืนยันการลบสินค้า", message: "คุณยืนยันการลบสินค้านี้ออกจากตะกร้าหรือไม่", action: "ยืนยัน", canceltext: "ยกเลิก", submit: {
                self.content.remove(at: indexPath.row)
                let data = CartInfo()
                data.items = self.content
                AppGlobal.storage.addCart(data)
                self.reloadContent()
            }, cancel: {})
        }
        return cell
    }
    
   
    @IBAction func actionJongya(_ sender: Any) {
        self.YSDShowAlertCancel("ยืนยันการจอง", message: "คุณต้องการจองสินค้าเลยหรือไม่", action: "ยืนยัน", submit: {
            let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "InvoiceViewController") as! InvoiceViewController
            AppGlobal.navigationController?.pushViewController(view, animated: true)
            }, cancel: {})
    }
}


class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amoutLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var hideButton: UIButton?
    
    var didDeleteItem : (() -> ())?
    var didhide : ((Bool) -> ())?
    
    var isShow : Bool = true {
        didSet {
            if isShow {
                hideButton?.backgroundColor = .lightGray
                hideButton?.setTitle("ซ่อน", for: .normal)
            } else {
                hideButton?.backgroundColor = AppGlobal.design.getColor(.green)
                hideButton?.setTitle("แสดง", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLabel.backgroundColor = AppGlobal.design.getColor(.coin)
        priceLabel.textColor = .white
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func deleteButtonDidPress(_ sender: Any) {
        self.didDeleteItem?()
    }
    
    @IBAction func hideButtonDidPress(_ sender: Any) {
        self.isShow = !self.isShow
        self.didhide?(self.isShow)
    }
}

