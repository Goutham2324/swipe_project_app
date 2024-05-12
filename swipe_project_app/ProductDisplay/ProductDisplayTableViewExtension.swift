//
//  ProductDisplayTableViewExtension.swift
//  Swipe_Assignment
//
//  Created by Swejan Kothamasu on 08/05/24.
//

import Foundation
import UIKit
//import Alamofire
//import AlamofireImage

extension ProductDisplayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsTableViewCell", for: indexPath) as! ProductDetailsTableViewCell
        let product = filteredProducts[indexPath.row]
        cell.productTitleLbl.text = product.product_name
        cell.productTaxLbl.text = "+ Tax: \(product.tax)"
        cell.productCategoryLbl.text = "Category: \(product.product_type)"
        cell.productPriceLbl.text = "Price: \(product.price)"
        
        cell.productImgView.image = nil
        if let imageUrlString = product.image, !imageUrlString.isEmpty, let imageUrl = URL(string: imageUrlString) {
            let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                // Ensure the downloaded image data belongs to the current cell
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if tableView.cellForRow(at: indexPath) == cell {
                            cell.productImgView.image = image
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.productImgView.image = UIImage(named: "defaultimg")
                    }
                }
            }
            task.resume()
        } else {
            cell.productImgView.image = UIImage(named: "defaultimg")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
