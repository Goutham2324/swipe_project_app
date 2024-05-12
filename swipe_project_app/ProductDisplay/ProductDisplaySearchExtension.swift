//
//  ProductDisplaySearchExtension.swift
//  Swipe_Assignment
//
//  Created by Swejan Kothamasu on 09/05/24.
//

import Foundation
import UIKit

extension ProductDisplayViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        productSearchBar.resignFirstResponder()
        productSearchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        productSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        productSearchBar.resignFirstResponder()
        toggleSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProducts = productArray
        } else {
            filteredProducts = productArray.filter { product in
                product.product_name.lowercased().contains(searchText.lowercased())
            }
        }
        productDetailsTblView.reloadData()
        setUpWhenNoResultsFound()
    }
    
    func setUpWhenNoResultsFound() {
        if filteredProducts.isEmpty {
            noResultsImgView.isHidden = false
            noResultsImgView.image = UIImage(named: "noSearchresults")
            view.bringSubviewToFront(noResultsImgView)
        } else {
            noResultsImgView.isHidden = true
        }
    }
    
}
