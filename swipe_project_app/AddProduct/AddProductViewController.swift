//
//  AddProductViewController.swift
//  Swipe_Assignment
//
//  Created by Swejan Kothamasu on 08/05/24.
//

import UIKit
import Alamofire

protocol passingNewProduct : AnyObject {
    func addingNewProduct(newProduct: ProductDisplayResponseModel)
}

class AddProductViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var productCateogaryLbl: UILabel!
    @IBOutlet weak var productTypeBtn: UIButton!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productTaxLbl: UILabel!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productTaxTextField: UITextField!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var editBtnImage: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedProductCategory: String?
    weak var delegate : passingNewProduct!
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUpUI() {
        navigationItem.title = "Add product"
        productImgView.image = UIImage(named: "3")
        productTypeBtn.showsMenuAsPrimaryAction = true
        productTypeBtn.setTitle("Choose", for: .normal)
        productTypeBtn.menu = addMenuItems()
        
        productNameLbl.text = "Product Name"
        productTaxLbl.text = "Product Tax"
        productPriceLbl.text = "Product Price"
        productCateogaryLbl.text = "Product Cateogary"
        
        productNameTextField.placeholder = "Enter Product Name"
        productPriceTextField.placeholder = "Enter Product Price"
        productTaxTextField.placeholder = "Enter Product Tax"
        
        productImgView.layer.cornerRadius = 75
        productImgView.image = UIImage(named: "defaultimg")
        
        editBtnImage.setTitle("Edit", for: .normal)
        
        setupTextFieldToolBar(productNameTextField)
        setupTextFieldToolBar(productPriceTextField)
        setupTextFieldToolBar(productTaxTextField)
        configRightBarButton()
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func configRightBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(SaveButtonTapped))
    }
    
    func addMenuItems() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Mobile", image: nil, handler: { action in
                self.selectedProductCategory = "Mobile"
                self.productTypeBtn.setTitle(action.title , for: .normal)
            }),
            UIAction(title: "Mac", image: nil, handler: { action in
                self.selectedProductCategory = "Mac"
                self.productTypeBtn.setTitle(action.title , for: .normal)
            }),
            UIAction(title: "Service", image: nil, handler: { action in
                self.selectedProductCategory = "Service"
                self.productTypeBtn.setTitle(action.title , for: .normal)
            }),
            UIAction(title: "Product", image: nil, handler: { action in
                self.selectedProductCategory = "Product"
                self.productTypeBtn.setTitle(action.title , for: .normal)
            }),
            UIAction(title: "Android", image: nil, handler: { action in
                self.selectedProductCategory = "Android"
                self.productTypeBtn.setTitle(action.title , for: .normal)
            }),
            UIAction(title: "Laptop", image: nil, handler: { action in
                self.selectedProductCategory = "Laptop"
                self.productTypeBtn.setTitle(action.title , for: .normal)
            })
        ])
        return menuItems
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func setupTextFieldToolBar(_ textField: UITextField) {
        textField.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var items = [flexibleSpace]
        
        if textField == productTaxTextField {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
            items.append(doneButton)
        } else {
            let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTextField))
            items.append(nextButton)
        }
        
        toolbar.setItems(items, animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func nextTextField() {
        if productNameTextField.isFirstResponder {
            productPriceTextField.becomeFirstResponder()
        } else if productPriceTextField.isFirstResponder {
            productTaxTextField.becomeFirstResponder()
        }
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func SaveButtonTapped() {
        if let productName = productNameTextField.text, productName.isEmpty {
            showAlert(message: "Please enter a product name.")
            return
        }
        guard let productName = productNameTextField.text else { return }
        
        if let productPrice = productPriceTextField.text, productPrice.isEmpty {
            showAlert(message: "Please enter a product price.")
            return
        }
        guard let productPrice = productPriceTextField.text, let price = Double(productPrice), price >= 0 else {
            showAlert(message: "Price must be a valid number.")
            return
        }

        if let productTax = productTaxTextField.text, productTax.isEmpty {
            showAlert(message: "Please enter the tax amount.")
            return
        }
        guard let productTax = productTaxTextField.text, let tax = Double(productTax), tax >= 0 else {
            showAlert(message: "Tax must be a valid number.")
            return
        }

        guard let productType = selectedProductCategory else {
            showAlert(message: "Please select a product category.")
            return
        }

        let parameters: [String: Any] = [
            "product_name": productName,
            "product_type": productType,
            "price": price,
            "tax": tax
        ]
        let url = "https://app.getswipe.in/api/public/add"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { [weak self] response in
            guard let self = self else { return }
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            switch response.result {
            case .success(let value):
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                let newProduct = ProductDisplayResponseModel(price: price, product_name: productName, product_type: productType, tax: tax)
                print("Success")
                print("\(value)")
                self.delegate?.addingNewProduct(newProduct: newProduct)
                self.showToast(message: "Product added successfully", completion: {
                    self.navigationController?.popViewController(animated: true)
                })

            case .failure(let error):
                print("\(error as Error)")
                self.showToast(message: "Failed to add product", completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeTextField = self.activeTextField else {
            return
        }

        let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: self.view.window)
        let textFieldBottom = textFieldFrame.maxY
        let keyboardTop = self.view.frame.height - keyboardFrame.height

        if textFieldBottom > keyboardTop {
            let offset = textFieldBottom - keyboardTop + 10
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= offset
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = 0
            }
        }
    }


    func showToast(message: String, completion: @escaping () -> Void) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(_ : Bool) -> Void in
            toastLabel.removeFromSuperview()
            completion()
        })
    }

    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
