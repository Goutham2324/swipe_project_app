//
//  ProductDisplayResponseModel.swift
//  Swipe_Assignment
//
//  Created by Swejan Kothamasu on 09/05/24.
//

import Foundation

struct ProductDisplayResponseModel : Codable {
    let price : Double
    let product_name: String
    let product_type: String
    let tax: Double
    let image: String?
    
    init(price: Double, product_name: String, product_type: String, tax: Double, image: String? = nil) {
        self.price = price
        self.product_name = product_name
        self.product_type = product_type
        self.tax = tax
        self.image = image
    }
}
