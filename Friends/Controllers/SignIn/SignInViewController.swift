//
//  SignInViewController.swift
//  Friends
//
//  Created by Emiray Nakip on 4.11.2021.
//

import UIKit

class SignInViewController: UIViewController {
    
    var viewTop : UIView = UIView()
    var heightConstraintViewTop : NSLayoutConstraint!
    
    var viewBottom : UIView = UIView()
    var heightConstraintViewBottom : NSLayoutConstraint!
    
    private lazy var loginView : LoginView = {
        let vw = LoginView()
        vw.delegate = self
        return vw
    }()
    
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        if UserDefaultsManager.shared.isUserSignedIn() {
            self.pushToListVC()
        } else {
            self.hideNavigationBar()
            self.setupLayouts()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.animationCollectAtTheCenter()
    }
    
    // MARK: - SETUP UI
    private func setupLayouts() {
        self.setupLayoutViewTop()
        self.setupLayoutViewBottom()
        self.setupLayoutLoginView()
    }
    
    private func setupLayoutViewTop() {
        
        viewTop.backgroundColor = .myDarkBlue
        viewTop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewTop)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        self.heightConstraintViewTop = viewTop.heightAnchor.constraint(equalToConstant: 0.0)
        
        NSLayoutConstraint.activate([
            viewTop.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            viewTop.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            viewTop.topAnchor.constraint(equalTo: view.topAnchor),
            self.heightConstraintViewTop
        ])
        
    }
    
    private func setupLayoutViewBottom() {
        viewBottom.backgroundColor = .myLightBlue
        viewBottom.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewBottom)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        self.heightConstraintViewBottom = viewBottom.heightAnchor.constraint(equalToConstant: 0.0)
        
        NSLayoutConstraint.activate([
            viewBottom.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            viewBottom.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            viewBottom.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            self.heightConstraintViewBottom
        ])
    }
    
    
    private func setupLayoutLoginView() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.alpha = 0.0
        view.addSubview(loginView)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            loginView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            loginView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            loginView.widthAnchor.constraint(equalToConstant: 300.0),
            loginView.heightAnchor.constraint(equalToConstant: 172.0)
        ])
    }
    
    // MARK: - ANIMATIONS
    @objc func animationCollectAtTheCenter() {
        UIView.animate(withDuration: 0.6) {  [weak self] in
            guard let self = self else { return }
            self.heightConstraintViewTop.constant = self.view.frame.height/2
            self.heightConstraintViewBottom.constant = self.view.frame.height/2
            self.view.layoutIfNeeded()
        } completion: { (done) in
            if done {
                
                self.animateLoginView()
            }
        }
    }
    
    @objc func animationSeperate() {
        UIView.animate(withDuration: 0.6) {  [weak self] in
            guard let self = self else { return }
            self.heightConstraintViewTop.constant = 0.0
            self.heightConstraintViewBottom.constant = 0.0
            self.loginView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateLoginView() {
        
        loginView.transform = CGAffineTransform(scaleX: 4, y: 4)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.loginView.alpha = 1
            self.loginView.transform = CGAffineTransform.identity
        }
        
    }
    
    // MARK: - ACTIONS
    @objc private func actionButtonTapX() {
        self.animationSeperate()
    }
    
    @objc private func actionButtonTapLogin() {
        self.animationCollectAtTheCenter()
    }
    
}

extension SignInViewController: LoginViewDelegate {
    func buttonLoginTap(success: Bool) {
        if success {
            Logger.shared.prettyPrint("SUCCESS LOGIN")
            self.pushToListVC()
        } else {
            Logger.shared.prettyPrint("FAIL LOGIN")
        }
    }
    
    private func pushToListVC() {
        let listVC : ListViewController = ListViewController()
        listVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(listVC, animated: true)
      //  self.navigationController?.present(listVC, animated: false, completion: {
      //      self.showNavigationBar()
      //  })
    }
}
