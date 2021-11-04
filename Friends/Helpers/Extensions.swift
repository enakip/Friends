//
//  Extensions.swift
//  
//
//  Created by Emiray Nakip on 3.08.2021.
//

import Foundation
import UIKit

let viewSpinner : UIView = UIView()
var activityindicatorView : UIActivityIndicatorView?

let button = UIButton(type: .custom)

// MARK: -
extension UIViewController {

    // MARK: NAVIGATION BAR
    func hideNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
        
    }

    func showNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title

        } else {
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }
    
    // MARK: ActivityIndicator
    func startActivityIndicator(mainView: UIView) {
        
        viewSpinner.backgroundColor = .clear//UIColor.darkGray.withAlphaComponent(0.5)
        viewSpinner.layer.masksToBounds = true
        viewSpinner.layer.cornerRadius = 8.0
        viewSpinner.layer.zPosition = 1
        viewSpinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewSpinner)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            viewSpinner.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            viewSpinner.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            viewSpinner.widthAnchor.constraint(equalToConstant: 100.0),
            viewSpinner.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        activityindicatorView = UIActivityIndicatorView.init()
        if #available(iOS 13, *) {
            activityindicatorView?.style = .large
        } else {
            activityindicatorView?.style = .whiteLarge
        }
        activityindicatorView?.color = .myDarkBlue
        activityindicatorView?.translatesAutoresizingMaskIntoConstraints = false
        activityindicatorView?.startAnimating()
        viewSpinner.addSubview(activityindicatorView!)
       
        NSLayoutConstraint.activate([
            activityindicatorView!.centerXAnchor.constraint(equalTo: viewSpinner.centerXAnchor),
            activityindicatorView!.centerYAnchor.constraint(equalTo: viewSpinner.centerYAnchor)
        ])
        
    }
    
    func stopActivityIndicator() {
        activityindicatorView?.stopAnimating()
        activityindicatorView?.removeFromSuperview()
        viewSpinner.removeFromSuperview()
    }
    
    // MARK: ALERT
    func showAlert(mesg:String) {
        let alert = UIAlertController(title: "Error",
                                      message: mesg,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // MARK: DISMISS
    func dismiss() {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: ***
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

// MARK: -
extension UIView {
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func width() -> CGFloat {
        return self.frame.size.width
    }
    
    func height() -> CGFloat {
        return self.frame.size.height
    }
    
    func setCornerRound(value:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = value
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setBorder(width:CGFloat, color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

// MARK: - NOTIFICATION
extension Notification.Name {
    static let notificationCloseCharacter = Notification.Name(rawValue: "notificationCloseCharacter")
}

// MARK: - BUNDLE
extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
}

// MARK: - NSObject
extension NSObject {
    
    /// String describing the class name.
    static var className: String {
        return String(describing: self)
    }
    
}

// MARK: - UITABLEVIEW
extension UITableView {
   
    public func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell of class \(type.className)")
        }
        return cell
    }
    
}

// MARK: - UICOLOR
extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(red: Int, green: Int, blue: Int, reqAlpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: reqAlpha)
    }
    static var peaGreen: UIColor { return UIColor(hexFromString: "#7dbf0d")}
    
}

// MARK: - UITEXTFIELD
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    func enablePasswordToggle(){
        
        button.setImage(UIImage(named: "password_show")!, for: .normal)
        button.setImage(UIImage(named: "password_show")!, for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        self.rightView = button
        rightViewMode = .always
        button.alpha = 1.0
    }
    
    @objc private func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }
    
}

// MARK: - UITEXTVIEW
extension UITextView {
    
    func setPadding(left:CGFloat, right:CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: 7, left: left, bottom: 0, right: right)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Tamam",
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }
}

// MARK: - UILABEL
extension UILabel {
    func setDoubleFont(text1:String, font1:UIFont, color1: UIColor,text2:String, font2:UIFont, color2: UIColor) {
        let attrs1 = [NSAttributedString.Key.font : font1, NSAttributedString.Key.foregroundColor : color1]
        
        let attrs2 = [NSAttributedString.Key.font : font2,
                      NSAttributedString.Key.foregroundColor : color2,
                      NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        
        let attributedString1 = NSMutableAttributedString(string:text1, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:text2, attributes:attrs2)
        
     //   let attributedString2 : [NSAttributedString.Key : Any] = [
     //       .font : UIFont.fontRegular14,
     //       .foregroundColor : Colors().colorDarkGray,
     //       .underlineStyle : NSUnderlineStyle.single.rawValue
     //   ]
        
        attributedString1.append(attributedString2)
        
        self.attributedText = attributedString1
    }
}

// MARK: - UIBUTTON
extension UIButton {
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        self.adjustsImageWhenHighlighted = false
        self.isHighlighted = false
        self.isSelected = !isSelected
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}

// MARK: - UIImage
extension UIImage {
    func withColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }
        color.setFill()
        ctx.translateBy(x: 0, y: size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.clip(to: CGRect(x: 0, y: 0, width: size.width, height: size.height), mask: cgImage)
        ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return colored
    }
}

//MARK: - Validation

extension String {
    
    enum ValidityType {
        case email
        case phoneNumber
        case password
    }
    
    enum Regex: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case phoneNumber = "^(?=.*[0-9]).{10}$"
        case password = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
    }
    
    func isValid(_ validityType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validityType {
            case .email:
                regex = Regex.email.rawValue
            case .phoneNumber:
                regex = Regex.phoneNumber.rawValue
            case .password:
                regex = Regex.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}

// MARK: - UISTACKVIEW
extension UIStackView {
   
    convenience init(alignment: UIStackView.Alignment = .fill,
                     arrangedSubviews: [UIView],
                     axis: NSLayoutConstraint.Axis,
                     distribution: UIStackView.Distribution = .fill,
                     spacing: CGFloat = 0) {
        arrangedSubviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        self.init(arrangedSubviews: arrangedSubviews)
        self.alignment = alignment
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
    
    //  USAGE;
    //let view1 = UIView()
    //view1.backgroundColor = .systemPink
    //let view2 = UIView()
    //view2.backgroundColor = .systemOrange
    //let view3 = UIView()
    //view3.backgroundColor = .systemTeal

    //let stackView = UIStackView(alignment: .leading,
    //                            arrangedSubviews: [view1, view2, view3],
    //                            axis: .vertical,
    //                            distribution: .fill,
    //                            spacing: 20)



    //let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    //view.backgroundColor = .systemBlue
    //view.addSubview(stackView)
    //stackView.translatesAutoresizingMaskIntoConstraints = false

    //NSLayoutConstraint.activate([
    //    view1.heightAnchor.constraint(equalToConstant: 50),
    //    view1.widthAnchor.constraint(equalToConstant: 150),
    //    view2.heightAnchor.constraint(equalToConstant: 50),
    //    view2.widthAnchor.constraint(equalToConstant: 150),
    //    view3.heightAnchor.constraint(equalToConstant: 50),
    //    view3.widthAnchor.constraint(equalToConstant: 150),
    //    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    //])
    
    /// Removes all arranged subviews and their constraints from the view.
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
    
    //      USAGE;
    //      let view1 = UIView()
    //      let view2 = UIView()
    //      let view3 = UIView()

    //      let stackView = UIStackView()

    //      //Add subviews to stackView
    //      stackView.addArrangedSubview(view1)
    //      stackView.addArrangedSubview(view2)
    //      stackView.addArrangedSubview(view3)

    //      //Remove views from stackView
    //      stackView.removeAllArrangedSubviews()

}

// MARK: - NSMUTABLEATTRIBUTEDSTRING
extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)

        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont.boldFont(ofSize: 14), range: range)
    }

}


// MARK: - UITAPGESTURERECOGNIZER
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
