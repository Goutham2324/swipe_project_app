//
//  ProductDisplayViewController.swift
//  Swipe_Assignment
//
//  Created by Swejan Kothamasu on 08/05/24.
//

import Foundation
import UIKit
import Alamofire

class ProductDisplayViewController: UIViewController {
    
    @IBOutlet weak var productDetailsTblView: UITableView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var noResultsImgView: UIImageView!
    @IBOutlet weak var productTblViewTop: NSLayoutConstraint!
    
    var productArray = [ProductDisplayResponseModel]()
    var filteredProducts = [ProductDisplayResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpUI()
    }
    
    func setUpUI() {
        navigationItem.title = "Products"
        loadingActivityIndicator.startAnimating()
        setUpTableView() 
        productSearchBar.delegate = self
        noResultsImgView.isHidden = true
        configRightBarButton()
        productSearchBar.isHidden = true
    }
    
    func configRightBarButton(){
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named : "Plus"), style: .done, target: self, action: #selector(addProductRightBarBtn)),
            UIBarButtonItem(image: UIImage(named : "Search"), style: .done, target: self, action: #selector(toggleSearchBar))
        ]
    }
    
    
    func setUpTableView() {
        productTblViewTop.constant = -50
        productDetailsTblView.delegate = self
        productDetailsTblView.dataSource = self
        makeApiCall()
    }
    
    func makeApiCall() {
        fetchProductDetails { [weak self] fetchedProducts in
            DispatchQueue.main.async {
                self?.productArray = fetchedProducts
                self?.filteredProducts = fetchedProducts
                self?.productDetailsTblView.reloadData()
                self?.loadingActivityIndicator.stopAnimating()
                self?.loadingActivityIndicator.isHidden = true
                
            }
        }
    }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func fetchProductDetails(completion: @escaping ([ProductDisplayResponseModel]) -> Void) {
        let url = "https://app.getswipe.in/api/public/get"
        
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess, let data = response.data else {
                print("Error while fetching products: \(String(describing: response.result.error))")
                completion([])
                return
            }
            do {
                let products = try JSONDecoder().decode([ProductDisplayResponseModel].self, from: data)
                completion(products)
            } catch {
                print("Error decoding products: \(error)")
                completion([])
                self.loadingActivityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func addProductRightBarBtn() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func toggleSearchBar() {
        if productSearchBar.isHidden {
            productTblViewTop.constant = 0
            productSearchBar.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        } else {
            productTblViewTop.constant = -50
            productSearchBar.isHidden = true
            productSearchBar.resignFirstResponder()
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    
}

extension ProductDisplayViewController: passingNewProduct {
    func addingNewProduct(newProduct: ProductDisplayResponseModel) {
        productArray.insert(newProduct, at: 0)
        filteredProducts.insert(newProduct, at: 0)
        DispatchQueue.main.async {
            self.productDetailsTblView.reloadData()
            self.setUpWhenNoResultsFound()
        }
    }
}

