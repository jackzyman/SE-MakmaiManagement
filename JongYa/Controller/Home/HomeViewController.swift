//
//  HomeViewController.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit
import Kingfisher
import GRDB

class HomeViewController: MainMenuViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var searhTextField: UITextField!
    @IBOutlet weak var navBarSpaecTop: NSLayoutConstraint!
    
    //    @IBOutlet weak var searhbarButton: UISearchBar!
    var topRefreshControl: UIRefreshControl!
    
    var contents : [DrugDB] = []
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        //checkCart()
//        
//        selectDrugDatabase()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCart()
        selectDrugDatabase()
    }
    
    
    @IBAction func searchFieldTextEditing(_ sender: UITextField) {
            selectDrugDatabase(sender.text ?? "")
    } 

    @IBAction func didScanButtonPress(_ sender: Any) {
        let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        view.callCode = { code in
            self.selectDrugCode(code)
        }
        self.present(view, animated: true, completion: nil)
    }
    
    
    func checkCart(){
        if AppGlobal.storage.getCart().items.count > 0 {
            amountView.isHidden = false
            amountLabel.text = AppGlobal.storage.getCart().items.count.mpCMNumber()
        } else {
            amountView.isHidden = true
        }
        
        AppGlobal.db.checkInvoieDBStatus()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navBarSpaecTop.constant = AppGlobal.design.statusBarHeight
        
//        self.menuRightButton?.YSDsetColorImage(.white)
        self.addTopRefresh()
        selectDrugDatabase("")
        checkCart()

    }
    
    func addTopRefresh(){
        topRefreshControl = UIRefreshControl()
        topRefreshControl.addTarget(self, action: #selector(self.topRefresh(_:)), for: .valueChanged)
        collectionView.addSubview(topRefreshControl)
    }
    
    @objc private func topRefresh(_ sender:AnyObject) {
        selectDrugDatabase("")
        checkCart()
    }
    
    func selectDrugCode(_ code: String = ""){
        try! appDatabase.inDatabase { db in
            if let item = try DrugDB.filter(Column("id").like("%\(code)%")).fetchOne(db) {
                let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                view.content = item
                AppGlobal.navigationController?.pushViewController(view, animated: true)
            } else {
                YSDShowAlertOK("ไม่พบสินค้าในคลัง", message: "ไม่พบสินค้า id \(code)", action: "ตกลง", completion: {})
            }
        }
    }
    
    func selectDrugDatabase(_ text: String = ""){
        checkCart()
        contents = []
        try! appDatabase.inDatabase { db in
            let drugDBs  =  try DrugDB.filter(Column("name").like("%\(text)%")).order(Column("sold").desc).fetchAll(db) 
            if drugDBs.count > 0 {
                for i in 0...drugDBs.count - 1 {
                    if drugDBs[i].active {
                        contents.append(drugDBs[i])
                    }
                }
            }
            self.collectionView.reloadData()
            self.topRefreshControl.endRefreshing()
        }
    }
    
    override func didMenuRightButtonPress() {
        let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        AppGlobal.navigationController?.pushViewController(view, animated: true)
    }
    
}

//extension HomeViewController: UISearchBarDelegate {
//    func setupSearchBar() {
//        searhbarButton.delegate = self
//    }
//    
//    // Search Bar
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !searchText.isEmpty else {
//            currentContent = contents
//            collectionView.reloadData()
//            return
//        }
//        currentContent = contents.filter({ (DrugInfo) -> Bool in
//            DrugInfo.name.lowercased().contains(searchText.lowercased())
//        })
//        collectionView.reloadData()
//    }
//}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2, height: (self.view.frame.width/2) + 60)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        let item = contents[indexPath.row]
        
        if let url = URL(string: item.image) {
            cell.imageContent.kf.setImage(with: url)
        } else if let data = NSData(base64Encoded: item.image, options: .ignoreUnknownCharacters){
            cell.imageContent.image = UIImage(data: data as Data)
        } else {
            cell.imageContent.image = AppGlobal.design.noImage
        }
        
        cell.isRecommend = indexPath.row < 5
        cell.isSoldout = item.stock <= 0
        
        cell.titleNameLabel.text = item.name
        cell.detailLabel.text = item.detail
        cell.priceLabel.text = "  ฿" + item.price.mpCMNumber() + "  "
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = contents[indexPath.row]
        let view = AppGlobal.storyboard.main.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        view.content = item
        AppGlobal.navigationController?.pushViewController(view, animated: true)
        
    }
}
