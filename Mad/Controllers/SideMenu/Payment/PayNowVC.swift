//
//  PayNowVC.swift
//  Mad
//
//  Created by MAC on 03/08/2021.
//

import Foundation
import UIKit
import Stripe
import RxSwift
import RxCocoa

class CheckoutViewController: UIViewController {
    
    var paymentIntentClientSecret: String?
    var cartVM = CartViewModel()
    var disposeBag = DisposeBag()
 
    lazy var cardTextField: STPPaymentCardTextField = {
    let cardTextField = STPPaymentCardTextField()
    cardTextField.translatesAutoresizingMaskIntoConstraints = false
    return cardTextField
  }()

  lazy var payButton: UIButton = {
    let button = UIButton(type: .custom)
    button.layer.cornerRadius = 25
    button.backgroundColor = #colorLiteral(red: 1, green: 0.6392156863, blue: 0, alpha: 1)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
    button.setTitle("Pay now", for: .normal)
    button.addTarget(self, action: #selector(pay), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

    
    lazy var backButton: UIButton = {
      let button = UIButton(type: .custom)
      button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "Group 119"), for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()

    lazy var titleLbl: UILabel = {
      let button = UILabel()
        button.text = "My cart - Payment"
        button.textColor = #colorLiteral(red: 0.1176470588, green: 0.2156862745, blue: 0.4, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
      return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    StripeAPI.defaultPublishableKey = "pk_test_51GyE2kEh66Mr30iHouPsi3IfxNmFNI1IsBFvASIERi9RsbFXeOfQyiC3r5cwqwE7OYjqTcJIa1bFWsj84h9nayt500EB57inlh"
      
      //"pk_test_51JKJ4jG4ObXTFzUIqnUT18la6OUPL91V1OPvjSA9IkTm288rIWpB4p9DjzIvi1UICjq2Ufi7IphdpIpojT6CGZ4P00EJWzoYw4"
    view.backgroundColor = .white
    view.addSubview(titleLbl)
    titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    titleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
    
    view.addSubview(backButton)
    backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
    backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
    
    view.addSubview(cardTextField)
    cardTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    cardTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
    cardTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    cardTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

    view.addSubview(payButton)
    payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    payButton.topAnchor.constraint(equalTo: cardTextField.topAnchor, constant: 300).isActive = true
    payButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
    payButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    startCheckout()
  }

  func displayAlert(title: String, message: String, restartDemo: Bool = false) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel))
      self.present(alert, animated: true, completion: nil)
    }
  }

    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
  @objc func pay() {
    cartVM.showIndicator()
    guard let paymentIntentClientSecret = paymentIntentClientSecret else {return}
    // Collect card details
    let cardParams = cardTextField.cardParams
    let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
    let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
    paymentIntentParams.paymentMethodParams = paymentMethodParams
    // Submit the payment
    let paymentHandler = STPPaymentHandler.shared()
    paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
      switch (status) {
      case .failed:
        self.cartVM.dismissIndicator()
          self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
          break
      case .canceled:
        self.cartVM.dismissIndicator()
          self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
          break
      case .succeeded:
        self.cartVM.dismissIndicator()
          self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "")
          break
      @unknown default:
          fatalError()
          break
      }
    }
  }

    func startCheckout() {
        cartVM.showIndicator()
        cartVM.generateClientSecret().subscribe(onNext: { (dataModel) in
           if dataModel.success ?? false {
               self.paymentIntentClientSecret = dataModel.data
               self.cartVM.dismissIndicator()
           }
       }, onError: { (error) in
        self.cartVM.dismissIndicator()
       }).disposed(by: disposeBag)
   }
}

extension CheckoutViewController: STPAuthenticationContext {
  func authenticationPresentingViewController() -> UIViewController {
      return self
  }
    
}
