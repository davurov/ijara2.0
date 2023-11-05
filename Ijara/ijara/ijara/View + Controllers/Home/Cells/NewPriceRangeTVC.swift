//
//  NewPriceRangeTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 30/10/23.
//

import UIKit

class NewPriceRangeTVC: UITableViewCell {

    //MARK: Elements
    let priceRangeLbl = UILabel()
    let sliderView = UIView()
    let leftCircle = UIView()
    let rightCircle = UIView()
    let swipeControlView = UIView()
    let minimumLbl = UILabel()
    let maximumLbl = UILabel()
    var statisticViews: [UIView] = []
    
    //MARK: Variables
    static let identifier: String = String(describing: NewPriceRangeTVC.self)
    let sliderWidth: CGFloat = 330
    let circleSize: CGFloat = 30
    /// `numberOfParts` this variable equal to number of costs which user can choose
    let numberOfParts: CGFloat = 30
    var leftCircleX: CGFloat = 15 {
        didSet {
            minPrice = Int(leftCircleX/(rightCircleMaxX/numberOfParts)) * 500000
        }
    }
    var rightCircleX: CGFloat = 315 {
        didSet {
            maxPrice = Int(rightCircleX/(rightCircleMaxX/numberOfParts)) * 500000
        }
        
    }
     var minPrice = 500000 {
        didSet {
            minimumLbl.text = "\(SetLanguage.setLang(type: .minimum)): \n \(minPrice)"
            NewPriceRangeTVC.minPriceFiltr = minPrice
        }
    }
     var maxPrice = 15000000 {
        didSet {
            maximumLbl.text = "\(SetLanguage.setLang(type: .maximum)): \n \(maxPrice)"
            NewPriceRangeTVC.maxPriceFiltr = maxPrice
        }
    }
    
    var rightCircleMaxX: CGFloat {
        return sliderWidth - circleSize/2
    }
    
    static var maxPriceFiltr = 15000000
    static var minPriceFiltr = 500000
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: @objc functions
    
    @objc func sliderSwiping(_ gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: swipeControlView)
        
        if isNotOverBorder(location.x, location.y) {
            if location.x > leftCircleX-25 && location.x < leftCircleX + 25 && location.x < rightCircleX-circleSize/2 {
                leftCircle.frame.origin.x = location.x-circleSize/2
                leftCircleX = leftCircle.frame.origin.x+circleSize/2
            }
            
            if location.x > rightCircleX-25 && location.x < rightCircleX+25 && location.x > leftCircleX+circleSize/2 {
                rightCircle.frame.origin.x = location.x-circleSize/2
                rightCircleX = rightCircle.frame.origin.x+circleSize/2
            }
        }
        
    }
    
    func clearChanged(){
        leftCircleX = 15
        rightCircleX = 315
        minPrice = 500000
        maxPrice = 15000000
    }
    
    //MARK: Functions
    
    ///Check that circls is not over border from horizonal and vertical
    func isNotOverBorder(_ locationX: CGFloat, _ locationY: CGFloat) -> Bool {
        if locationY > 0 && locationY < circleSize && locationX > circleSize/2 && locationX <= rightCircleMaxX {
            return true
        } else {
            return false
        }
    }
    
    func setupViews(){
        contentView.addSubview(priceRangeLbl)
        priceRangeLbl.translatesAutoresizingMaskIntoConstraints = false
        priceRangeLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        priceRangeLbl.text = SetLanguage.setLang(type: .priceRange)
        priceRangeLbl.textColor = AppColors.customBlack
        
        contentView.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.backgroundColor = .black
        
        sliderView.addSubview(leftCircle)
        leftCircle.translatesAutoresizingMaskIntoConstraints = false
        leftCircle.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        leftCircle.layer.cornerRadius = circleSize/2
        leftCircle.clipsToBounds = true
        leftCircle.layer.borderColor = UIColor.black.cgColor
        leftCircle.layer.borderWidth = 1
        
        sliderView.addSubview(rightCircle)
        rightCircle.translatesAutoresizingMaskIntoConstraints = false
        rightCircle.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        rightCircle.layer.cornerRadius = circleSize/2
        rightCircle.clipsToBounds = true
        rightCircle.layer.borderColor = UIColor.black.cgColor
        rightCircle.layer.borderWidth = 1
        
        contentView.addSubview(swipeControlView)
        swipeControlView.translatesAutoresizingMaskIntoConstraints = false
        swipeControlView.backgroundColor = .clear
        
        let sliderPanGesture = UIPanGestureRecognizer(target: self, action: #selector(sliderSwiping(_:)))
        swipeControlView.addGestureRecognizer(sliderPanGesture)
        
        contentView.addSubview(minimumLbl)
        minimumLbl.translatesAutoresizingMaskIntoConstraints = false
        minimumLbl.text = "\(SetLanguage.setLang(type: .minimum)): \n \(minPrice)"
        minimumLbl.textColor = AppColors.customBlack
        minimumLbl.font = .boldSystemFont(ofSize: 17)
        minimumLbl.textAlignment = .center
        minimumLbl.numberOfLines = 0
        
        contentView.addSubview(maximumLbl)
        maximumLbl.translatesAutoresizingMaskIntoConstraints = false
        maximumLbl.text = "\(SetLanguage.setLang(type: .maximum)): \n \(maxPrice)"
        maximumLbl.textColor = AppColors.customBlack
        maximumLbl.font = .boldSystemFont(ofSize: 17)
        maximumLbl.textAlignment = .center
        maximumLbl.numberOfLines = 0
        
        addConstraints()
        setStatisticViews()
    }
    
    func addConstraints(){
        NSLayoutConstraint.activate([
            priceRangeLbl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            priceRangeLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            sliderView.widthAnchor.constraint(equalToConstant: 330),
            sliderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sliderView.heightAnchor.constraint(equalToConstant: circleSize/10),
            sliderView.bottomAnchor.constraint(equalTo: minimumLbl.topAnchor, constant: -15),
            
            swipeControlView.leftAnchor.constraint(equalTo: sliderView.leftAnchor, constant: 0),
            swipeControlView.rightAnchor.constraint(equalTo: sliderView.rightAnchor, constant: 0),
            swipeControlView.topAnchor.constraint(equalTo: leftCircle.topAnchor, constant: 0),
            swipeControlView.bottomAnchor.constraint(equalTo: leftCircle.bottomAnchor, constant: 0),
            
            leftCircle.leftAnchor.constraint(equalTo: sliderView.leftAnchor, constant: 0),
            leftCircle.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor),
            leftCircle.widthAnchor.constraint(equalToConstant: circleSize),
            leftCircle.heightAnchor.constraint(equalToConstant: circleSize),
            
            rightCircle.rightAnchor.constraint(equalTo: sliderView.rightAnchor, constant: 0),
            rightCircle.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor),
            rightCircle.widthAnchor.constraint(equalToConstant: circleSize),
            rightCircle.heightAnchor.constraint(equalToConstant: circleSize),
            
            minimumLbl.leftAnchor.constraint(equalTo: sliderView.leftAnchor, constant: 10),
            minimumLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            minimumLbl.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 25),
            
            maximumLbl.rightAnchor.constraint(equalTo: sliderView.rightAnchor, constant: -10),
            maximumLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
//            maximumLbl.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 25),
        ])
    }
    
    func setStatisticViews(){
        for line in 0...14 {
            let lineView = UIView()
            contentView.addSubview(lineView)
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            lineView.layer.cornerRadius = 3
            lineView.clipsToBounds = true
            
            let height: CGFloat = 25
            var lineHeight: CGFloat
            
            switch line {
            case 0:  lineHeight = height
            case 1:  lineHeight = height*3
            case 2:  lineHeight = height*2.5
            case 3:  lineHeight = height*2
            case 4:  lineHeight = height
            case 5:  lineHeight = height/3
            default: lineHeight = 0
            }
            
            NSLayoutConstraint.activate([
                lineView.widthAnchor.constraint(equalToConstant: 3),
                lineView.heightAnchor.constraint(equalToConstant: lineHeight),
                lineView.leftAnchor.constraint(equalTo: leftCircle.leftAnchor, constant: 15 + CGFloat(20 * line)),
                lineView.bottomAnchor.constraint(equalTo: leftCircle.topAnchor, constant: -10)
            ])
            
            
            statisticViews.append(lineView)
            
        }
    }
    
    func statisticLine() -> UIView {
        let line = UIView()
        contentView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        line.layer.cornerRadius = 3
        line.clipsToBounds = true
        NSLayoutConstraint.activate([
            line.widthAnchor.constraint(equalToConstant: 3),
            line.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        return line
    }
}
