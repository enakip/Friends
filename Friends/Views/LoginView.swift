//
//  LoginView.swift
//
//
//  Created by Emiray on 13.04.2021.
//

import UIKit

protocol LoginViewDelegate {
    func buttonLoginTap(success:Bool)
}

class LoginView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var textfieldUserName: UITextField! {
        didSet {
            textfieldUserName.placeholder = "Username"
            textfieldUserName.font = .semiBoldFont(ofSize: 14)
            textfieldUserName.textColor = .myDarkBlue
            textfieldUserName.addDoneButtonOnKeyboard()
        }
    }
    @IBOutlet weak var textfieldPassword: UITextField! {
        didSet {
            textfieldPassword.placeholder = "Passowrd"
            textfieldPassword.font = .semiBoldFont(ofSize: 14)
            textfieldPassword.textColor = .myDarkBlue
            textfieldPassword.isSecureTextEntry = true
            textfieldPassword.addDoneButtonOnKeyboard()
        }
    }
    
    @IBOutlet weak var buttonLogin : UIButton! {
        didSet {
            buttonLogin.titleLabel?.font = .semiBoldFont(ofSize: 16)
            buttonLogin.setTitleColor(.myWhite, for: .normal)
            buttonLogin.backgroundColor = .myDarkBlue
            buttonLogin.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        }
    }
    
    var delegate : LoginViewDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    // MARK: - Views Setup
    func loadView() {
        let bundle = Bundle(for: LoginView.self)
        let nib = UINib(nibName: "LoginView", bundle: bundle)
        let view = nib.instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.layer.cornerRadius = 6.0
        addSubview(view)
    }

    // MARK: - Actions
    @objc private func buttonTap() {
        guard let textUsername = textfieldUserName.text else {
            return
        }
        
        guard let textPassword = textfieldPassword.text else {
            return
        }
        
        if textUsername.isEmpty {
            self.parentViewController?.showAlert(mesg: "Please enter username")
            return
        }
        
        if textPassword.isEmpty {
            self.parentViewController?.showAlert(mesg: "Please enter password")
            return
        }
           
        let username : String = (Bundle.main.infoDictionary?["USERNAME"]) as? String ?? ""
        let password : String = (Bundle.main.infoDictionary?["PASSWORD"]) as? String ?? ""
   
        if textUsername == username && textPassword == password {
            self.delegate?.buttonLoginTap(success: true)
            UserDefaultsManager.shared.signInUser()
        } else {
            self.parentViewController?.showAlert(mesg: "Please enter true username & password")
            self.delegate?.buttonLoginTap(success: false)
        }
    }
}
