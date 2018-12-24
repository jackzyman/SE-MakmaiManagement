//
//  CollectionViewCell.swift
//  JongYa
//
//  Created by Jarukit Rungruang on 15/10/18.
//  Copyright © 2018 Jarukit Rungruang. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageContent: UIImageView! 
    @IBOutlet weak var titleNameLabel: UILabel! 
    @IBOutlet weak var detailLabel: UILabel! 
    @IBOutlet weak var priceLabel: UILabel! 
    
    @IBOutlet weak var soldoutImageView: UIImageView! 
    @IBOutlet weak var recommendImageView: UIImageView! 
    
    
    var isRecommend = false {
        didSet {
            recommendImageView.isHidden = !isRecommend
        }
    }
    
    var isSoldout = false {
        didSet {
            soldoutImageView.isHidden = !isSoldout
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        soldoutImageView.isHidden = true
        recommendImageView.isHidden = true
        
        priceLabel.backgroundColor = AppGlobal.design.getColor(.coin)
        priceLabel.textColor  = .white
    }
    
    override func prepareForReuse() {
        soldoutImageView.isHidden = true
        recommendImageView.isHidden = true
    }

}
