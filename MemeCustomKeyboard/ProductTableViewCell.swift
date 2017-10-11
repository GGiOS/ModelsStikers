//
//  ProductTableViewCell.swift
//  InAppPurchases-Exercise
//
//  Created by GGiOS on 2017-01-23.
//  Copyright © 2017 Jadhabal. All rights reserved.
//

import UIKit
@IBDesignable

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var modelImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var goToDetail: CustomButton!
    
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productStatus: CustomButton!
    
  //  @IBOutlet weak var collectionButton: UIButton!
 
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productStatus.layer.cornerRadius = 17
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureImage(image:UIImage){
        modelImage.image = image
    }
}
