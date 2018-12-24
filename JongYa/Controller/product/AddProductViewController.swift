//
//  AddProductViewController.swift
//  JongYa
//
//  Created by Methawee Punkaew on 22/12/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit
import MultilineTextField
import GRDB

class AddProductViewController: MainTableViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var leftSpaceSaveButton: NSLayoutConstraint!
    
    var callPicker : ((UIImage) -> ())?
    
    var currentDrug : DrugDB?
    
    let rows = ["รหัสสินค้า", "ชื่อสินค้า", "ราคา", "จำนวนในคลัง" , "รายละเอียด", "รูปภาพ"]
    var inputText : [String] = ["","","","","",""]
    var inputimage : UIImage?
    var imageText = ""
    var isEdit = false
    var addNewId : String?

    var stockUp = 0
    var stockDown = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfRowsInSection = rows.count
        menuRightButton?.YSDSetMain()
        deleteButton?.YSDSetSecondary()
        deleteButton.isHidden = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let drug = currentDrug {
            inputText[0] = drug.id
            inputText[1] = drug.name
            inputText[2] = "\(drug.price)"
            inputText[3] = "\(drug.stock)"
            inputText[4] = drug.detail
            inputText[5] = drug.image
            
            isEdit = true
            setHideEditing()
        }
        

        
        if let id = addNewId {
            inputText[0] = id
        }
        
        
        checkButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHideEditing(){
            deleteButton.isHidden = false
            leftSpaceSaveButton.constant = (self.view.frame.width/2)
    }
    
    func checkButton(){
        var isReady = true
        if inputText[0] == "" {
            isReady = false
        }
        if inputText[1] == "" {
            isReady = false
        }
        if inputText[2] == "" {
            isReady = false
        }
        if inputText[3] == "" || !isEdit {
            isReady = false
        }
        if inputText[4] == "" {
            isReady = false
        }
        menuRightButton?.YSDSetMain(isReady && (inputText[5] != "" || inputimage != nil))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell1", for:indexPath) as! AddProductTableViewCell
            
            cell.inputField.isEnabled = !(isEdit || addNewId != nil)
            cell.didActionButton = {
            let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
            view.callCode = { code in
                cell.inputField.text = code
                self.inputText[indexPath.row] = code
                self.checkButton()
                
            }
            self.present(view, animated: true, completion: nil)
            }
            
            cell.titleLabel.text = rows[indexPath.row]
            cell.inputField.placeholder = rows[indexPath.row]
            cell.inputField.text = inputText[indexPath.row]
            cell.didTextFieldEditingChange = { info in
                self.inputText[indexPath.row] = info
                self.checkButton()
            }
            
            return cell
        case 4:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell4", for:indexPath) as! AddProductTableViewCell
            cell.titleLabel.text = rows[indexPath.row]
            cell.inputTextView?.text = inputText[indexPath.row]
            cell.didTextFieldEditingChange = { info in
                self.inputText[indexPath.row] = info
                self.checkButton()
            }
            
            return cell
        case 5:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell5", for:indexPath) as! AddProductTableViewCell
            cell.titleLabel.text = rows[indexPath.row]
            cell.inputTextView?.text = inputText[indexPath.row]
            
            if let image = inputimage {
            cell.contentImage.image = image
            } else if let url = URL(string: inputText[indexPath.row]) {
                cell.contentImage.kf.setImage(with: url)
                cell.inputTextView?.text = inputText[indexPath.row]
            } else if let data = NSData(base64Encoded: inputText[indexPath.row], options: .ignoreUnknownCharacters){
                cell.contentImage.image = UIImage(data: data as Data)
            } 
            
            cell.didTextFieldEditingChange = { info in
                self.inputText[indexPath.row] = info
                self.checkButton()
            }
            
            cell.didActionButton = {
                self.choosePhoto()
                self.callPicker = { image in
                    self.inputimage = image
                    cell.contentImage.image = image
                    self.checkButton()
                }
                
            }
            
            return cell
        case 3: //Stock
            if isEdit {
                let cell  = tableView.dequeueReusableCell(withIdentifier: "cell3", for:indexPath) as! AddProductTableViewCell
                
                cell.titleLabel.text = rows[indexPath.row] + " (มีอยู่แล้ว \(inputText[indexPath.row]))"
                cell.inputField.placeholder = "เพิ่ม" + rows[indexPath.row]
                cell.downStockTestFeild.placeholder = "ลด" + rows[indexPath.row]
                
                cell.downStockTestFeild.keyboardType = .numberPad
                cell.inputField.keyboardType = .numberPad
                
                cell.didTextFieldEditingChange = { info in
                    if let num = Int(info) {
                        self.stockUp = num
                    } else {
                        self.stockUp = 0
                    }
                    cell.downStockTestFeild.text = nil
                    self.stockDown = 0
                    self.checkButton()
                }
                
                cell.downStock = { info in
                    if let num = Int(info) {
                        self.stockDown = num
                    } else {
                        self.stockDown = 0
                    }
                    cell.inputField.text = nil
                    self.stockUp = 0
                    self.checkButton()
                }
                return cell
            } else {
                let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! AddProductTableViewCell
                
                
                    cell.titleLabel.text = rows[indexPath.row]
                    cell.inputField.placeholder = rows[indexPath.row]
                
                
                cell.inputField.keyboardType = .numberPad
                cell.inputField.text = inputText[indexPath.row]
                cell.didTextFieldEditingChange = { info in
                    self.inputText[indexPath.row] = info
                    self.checkButton()
                }
                return cell
                
            }
            
        case 2:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! AddProductTableViewCell
            cell.titleLabel.text = rows[indexPath.row]
            cell.inputField.placeholder = rows[indexPath.row]
            cell.inputField.keyboardType = .numberPad
            cell.inputField.text = inputText[indexPath.row]
            cell.didTextFieldEditingChange = { info in
                self.inputText[indexPath.row] = info
                self.checkButton()
            }
            return cell
        default:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! AddProductTableViewCell
            cell.titleLabel.text = rows[indexPath.row]
            cell.inputField.placeholder = rows[indexPath.row]
            cell.inputField.text = inputText[indexPath.row]
            cell.didTextFieldEditingChange = { info in
                self.inputText[indexPath.row] = info
                self.checkButton()
            }
            
            return cell
        }
        
    }
    override func didMenuRightButtonPress() {
        checkImage()
    }
    
    @IBAction func didDeleteButtonPress(_ sender: Any) {
        if let drug = currentDrug {
            deleteDrug(drug)
        }
    }
    
    func deleteDrug(_ drug: DrugDB){
        self.YSDShowAlertCancel("ยืนยันการลบสินค้า", message: "คุณยืนยันการลบสินค้านี้ออกจากคลังสินค้า", action: "ยืนยัน", canceltext: "ยกเลิก", submit: {
            try! appDatabase.inDatabase { db in
                try DrugDB.filter(Column("id").like(drug.id)).deleteAll(db)
                self.dismissOrPop()
            }
        }, cancel: {})
    }
    
    func checkImage(){
//        if let _ = NSData(base64Encoded: inputText[5], options: .ignoreUnknownCharacters){
//            imageText = inputText[5]
//            self.insertDrug()
//        } else 
        if let image = inputimage {
            if let imageData = image.jpegData(compressionQuality: 1) as? NSData {
            imageText = imageData.base64EncodedString(options: .lineLength64Characters)
            self.insertDrug()
            } else {
                YSDShowAlertOK("ผิดพลาด", message: "ไม่สามารถแปลงข้อมูลรูปภาพได้", action: "ตกลง")
            }
        } else if inputText[5] != "" {
            if URL(string: inputText[5]) != nil {
                imageText = inputText[5]
                self.insertDrug()
            } else {
                YSDShowAlertOK("URL ไม่ถูกต้อง", message: "URL รูปภาพไม่ถูกต้อง กรุณาตรวจสอบใหม่อีกครั้ง", action: "ตกลง")
            }
            
        } 
    }
    
    
    func insertDrug(){
        if let drug = self.currentDrug {
            try! appDatabase.inDatabase { db in
                try DrugDB.filter(Column("id").like(drug.id)).deleteAll(db)
                let newDrug = DrugDB(id: inputText[0], name: inputText[1], detail: inputText[4], image: imageText, price: Int(inputText[2])!, stock: Int(inputText[3])! + stockUp - stockDown)
                try newDrug.insert(db)
                YSDShowAlertOK("สำเร็จ", message: "อัพเดตสินค้าในคลังเรียบร้อยแล้ว", action: "ตกลง", completion: {
                    self.dismissOrPop()
                })
            }
        } else {
            try! appDatabase.inDatabase { db in
            if let _ = try DrugDB.filter(Column("id").like(inputText[0])).fetchOne(db) {
                YSDShowAlertOK("ไม่สามารถเพิ่มสินค้าได้", message: "ไม่สามารถเพิ่มสินค้าได้ เนื่องจากมีสินค้ารหัสเดียวกันอยู่ในคลังสินค้าแล้ว", action: "ตกลง")
            } else {
                let newDrug = DrugDB(id: inputText[0], name: inputText[1], detail: inputText[4], image: imageText, price: Int(inputText[2])!, stock: Int(inputText[3])! + stockUp - stockDown)
                try newDrug.insert(db)
                    YSDShowAlertCancel("สำเร็จ", message: "เพิ่มสินค้าใหม่ลงในคลังเรียบร้อยแล้ว", action: "เพิ่มสินค้าอีก",canceltext: "ตกลง", submit:  {
                    self.inputText = ["","","","","",""]
                    self.inputimage = nil
                    self.imageText = ""
                    self.tableView.reloadData()
                }, cancel: {
                    self.dismissOrPop()
                })
            }
        }
        }
    }
    
}


class AddProductTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel! 
    @IBOutlet weak var inputField: UITextField! 
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var inputTextView: UITextView?
    
    @IBOutlet weak var downStockTestFeild: UITextField!
    var didTextFieldEditingChange : ((String) -> ())?
    var downStock : ((String) -> ())?
    var didActionButton : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inputTextView?.delegate = self
    }
    
    @IBAction func didTextFieldEditingChange(_ sender: UITextField) {
         didTextFieldEditingChange?(sender.text ?? "")
    }
    
    @IBAction func downChange(_ sender: UITextField) {
        downStock?(sender.text ?? "")
    }
    
    @IBAction func didActionButtonPress(_ sender: Any) {
        didActionButton?()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        didTextFieldEditingChange?(textView.text)
    }
    
    
}



extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func choosePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        guard let selectedImage = info[.originalImage] as? UIImage else {
//            prinr("Error: \(info)")
//        }
        if let selectedImage = info[.originalImage] as? UIImage {
            self.callPicker?(selectedImage)
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            callPicker?(pickedImage)
//        }
//        picker.dismissOrPop()
//    }
}
