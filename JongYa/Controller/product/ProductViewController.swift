//
//  TestViewController.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 22/10/18.
//  Copyright © 2561 Jarukit Rungruang. All rights reserved.
//

import UIKit
import Kingfisher

class ProductViewController: MainTableViewController {
    
    
    var content : DrugDB!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var inputPriceField: UITextField!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var hideAddView: UIView!
    @IBOutlet weak var addTocartButton: UIButton!
    @IBOutlet weak var stockLabel: UILabel!
    
    var count = 1
    var price = 1
    var isInMyCart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        numberOfRowsInSection = 1 
        
        priceLabel.textColor = .white
        priceLabel.backgroundColor = AppGlobal.design.getColor(.coin)
        
        
        //เช็คว่าเคยเอาลงตะกร้าไปรึยัง
        let cart = AppGlobal.storage.getCart()
        if cart.items.count > 0 {
            for i in 0...cart.items.count - 1 {
                if cart.items[i].drug.id == content.id {
                    content.stock = content.stock - cart.items[i].amount
                    self.isInMyCart = true
                    break
                }
            }
        }
        
        topLabel?.text = content.name
        price = content.price
        priceLabel.text = "  ฿" + content.price.mpCMNumber() + "  "
        hideAddView.isHidden  = content.stock > 0
        
        if content.stock <= 0 {
            inputPriceField.text = ""
            if isInMyCart {
                stockLabel.text = "อยู่ในตะกร้าแล้ว \(content.stock)" 
            } else {
                stockLabel.text = "สินค้าหมดชั่วคราว" 
                stockLabel.textColor = .red
            }
        } else {
            stockLabel.text = "เหลือในคลัง \(content.stock)"         }
        checkCount()
        
    }
    
    @IBAction func didPressUpButton(_ sender: Any) {
        count += 1
        checkCount()
    }
    
    @IBAction func didPressDownButton(_ sender: Any) {
        count -= 1
        checkCount()
    }
    
    func checkCount(){
        if count > content.stock {
            count = content.stock
        } else if count < 0 {
            count = 0
        } 
        inputPriceField.text = "\(count)"
        addTocartButton.YSDSetMain(count > 0 && content.stock > 0)
        sumLabel.text = "รวม \((count * price).mpCMNumber()) บาท"
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        if let text = sender.text,  let number = Int(text) {
            if number > content.stock {
                self.count = content.stock
                sender.text = "\(content.stock)"
            } else {
                self.count = number
            }
        } else {
            self.count = 0
        }
        checkCount()
    }
    
    
    @IBAction func cartButtonDidPress(_ sender: Any) {
        self.YSDShowAlertCancel("ยืนยัน", message: "เพิ่มสินค้าลงตะกร้าหรือไม่?", action: "ตกลง", canceltext: "ยกเลิก", submit: {
            AppGlobal.storage.addCart(self.content.toMappable(), amount: self.count)
            self.dismissOrPop()
        }, cancel: {
            
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! ProductTableViewCell
        
        if let url = URL(string: content.image) {
            cell.contentImageView.kf.setImage(with: url)
        } else if let data = NSData(base64Encoded: content.image, options: .ignoreUnknownCharacters){
            cell.contentImageView.image = UIImage(data: data as Data)
        } else {
            cell.contentImageView.image = AppGlobal.design.noImage
        }
        
        cell.isSoldout = content.stock <= 0 && !isInMyCart
        
        cell.titleLabel.text = content.name
        cell.detailLabel.text = content.detail
        return cell
    }
    
}





class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var soldoutImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        soldoutImageView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    var isSoldout = false {
        didSet {
            soldoutImageView.isHidden = !isSoldout
        }
    }
    
}

