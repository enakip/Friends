//
//  Fonts.swift
//  Friends
//
//  Created by Emiray Nakip on 3.11.2021.
//

import UIKit

extension UIFont {
    
    static func regularFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont(name: "SourceSansPro-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    static func semiBoldFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont(name: "SourceSansPro-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    static func boldFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont(name: "SourceSansPro-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }
    
}
