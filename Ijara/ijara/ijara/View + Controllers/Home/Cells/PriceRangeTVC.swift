//
//  PriceRangeTVC.swift
//  ijara
//
//  Created by Abduraxmon on 25/09/23.
//

import UIKit

class PriceRangeTVC: UITableViewCell {
    
    static let identifier: String = String(describing: PriceRangeTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var lineStack: UIStackView!
    
    @IBOutlet var linesColection: [UIView]!
    @IBOutlet weak var minView: UIView!
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var maxView: UIView!
    @IBOutlet weak var minTF: UITextField!
    @IBOutlet weak var maxTF: UITextField!
    
    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupPriceRange(_ prices: [Int]) {
        maxTF.text = "\(prices.max()!)"
        minTF.text = "\(prices.min()!)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = sliderView.bounds.width
        rangeSlider.frame = CGRect(x: 0, y: 0, width: width, height: 31.0)
    }
    
    func setupViews() {
        rangeSlider.backgroundColor = UIColor.clear
        sliderView.addSubview(rangeSlider)
        
        maxView.addBorder(size: 0.5)
        minView.addBorder(size: 0.5)
        
        minTF.addTarget(self, action: #selector(minChanged), for: .editingChanged)
        maxTF.addTarget(self, action: #selector(maxChanged), for: .editingChanged)
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        print(linesColection.count)
    }
    
    @objc func rangeSliderValueChanged() {
        let lower = Int(rangeSlider.lowerValue * 50.0)
        linesColection[lower].backgroundColor = .red
    }
    
    @objc func minChanged() {
        linesColection[0].constraints
    }
    
    @objc func maxChanged() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
