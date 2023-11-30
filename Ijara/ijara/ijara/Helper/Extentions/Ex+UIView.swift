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
        layer.shadowOpacity = 1//0.3
        layer.shadowRadius = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func addBorder(size: CGFloat) {
        layer.borderColor = AppColors.customGray6.cgColor
        layer.borderWidth = size
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
