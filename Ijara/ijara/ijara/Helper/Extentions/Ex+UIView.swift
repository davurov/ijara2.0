//
//  Ex+UIView.swift
//  ijara
//
//  Created by Abduraxmon on 14/08/23.
//

import UIKit


extension UIView {
    
    func addShadow(){
        layer.shadowColor = AppColors.mainColor.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func addBorder() {
        layer.borderColor = AppColors.mainColor.cgColor
        layer.borderWidth = 2
    }
    
    func addShadowCustom(offset: CGSize, color: CGColor, radius: CGFloat, opacity: Float){
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color
    }

    
    //MARK: - AddShadow to View
        
        func addShadowByHand(offset: CGSize, color: CGColor, radius: CGFloat, opacity: Float){
            self.layer.shadowOffset = offset
            self.layer.shadowOpacity = opacity
            self.layer.shadowRadius = radius
            self.layer.shadowColor = color
        }

}
