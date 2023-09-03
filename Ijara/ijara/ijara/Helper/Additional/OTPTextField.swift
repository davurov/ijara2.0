//
//  OTPTextField.swift
//  ijara
//
//  Created by Abduraxmon on 15/08/23.
//

import Foundation
import UIKit

@objc class OTPTextField: UITextField {
    /// Border color info for field
    public var otpBorderColor: UIColor = UIColor.black
    
    /// Border width info for field
    public var otpBorderWidth: CGFloat = 2
    
    public var shapeLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func initalizeUI(forFieldType type: DisplayType) {
        switch type {
        case .circular:
            layer.cornerRadius = bounds.size.width / 2
            break
        case .roundedCorner:
            layer.cornerRadius = 8
            backgroundColor = UIColor.white
//            addShadow(offset: CGSize(width: 0, height: 0), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.08249659254), radius: 4, opacity: 0.9)
            break
        case .square:
            layer.cornerRadius = 0
            break
        case .diamond:
            addDiamondMask()
            break
        case .underlinedBottom:
            addBottomView()
            break
        }
        
        // Basic UI setup
        if type != .diamond && type != .underlinedBottom {
            layer.borderColor = otpBorderColor.cgColor
            layer.borderWidth = otpBorderWidth
        }
        
        autocorrectionType = .no
        textAlignment = .center
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        
        _ = delegate?.textField?(self, shouldChangeCharactersIn: NSMakeRange(0, 0), replacementString: "")
    }
    
    // Helper function to create diamond view
    fileprivate func addDiamondMask() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.size.width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height / 2.0))
        path.addLine(to: CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height / 2.0))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = otpBorderWidth
        shapeLayer.fillColor = backgroundColor?.cgColor
        shapeLayer.strokeColor = otpBorderColor.cgColor
        
        layer.addSublayer(shapeLayer)
    }
    
    // Helper function to create a underlined bottom view
    fileprivate func addBottomView() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        path.close()
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = otpBorderWidth
        shapeLayer.fillColor = backgroundColor?.cgColor
        shapeLayer.strokeColor = otpBorderColor.cgColor
        
        layer.addSublayer(shapeLayer)
    }
}
