//
//  ProductDetailsTableViewCell.swift
//  Swipe_Assignment
//
//  Created by Swejan Kothamasu on 08/05/24.
//

import UIKit

class ProductDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productCategoryLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productTaxLbl: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
