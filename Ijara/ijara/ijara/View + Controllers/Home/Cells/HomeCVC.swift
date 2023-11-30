//
//  HomeCVC.swift
//  ijara
//
//  Created by Muslim on 28/08/23.
//

import UIKit
import SCPageControl
import SDWebImage

public enum SCPageStyle: Int {
    case SCNormal = 100
    case SCJAMoveCircle
    case SCJAFillCircle
    case SCJAFlatBar
}

protocol CellDelegate: AnyObject {
    func cellSelected(id: Int, images: [String], price: (working: Int, weekend:Int))
}

class HomeCVC: UICollectionViewCell {
    
    let containerView   = UIView()
    var collectionView  : UICollectionView!
    var pageController  = UIView()
    let verifiedImg     = UIImageView()
    let nameLbl         = UILabel()
    let priceLbl        = UILabel()
    let locationImg     = UIImageView()
    let locationLbl     = UILabel()
    let familyImg       = UIImageView()
    let womens          = UIImageView()
    let mans            = UIImageView()
    let mixImg          = UIImageView()
    let s_vForGuestType = UIStackView()
    let innirPool       = UIImageView()
    let outerPool       = UIImageView()
    let s_vForPool      = UIStackView()
    var alcoholImg      = UIImageView()
    let sc              = SCPageControlView()
    
    static let identifier: String = String(describing: HomeCVC.self)
    var images = [String]()
    var price = (working: 0, weekend:0)
    var id = 0
    weak var cellDelegate: CellDelegate?
    /// variable to check that is it first time called
    var isConfigured = false
    
    //MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //MARK: functions
    
    private func commonInit() {
        // This setup will only run once, even if the cell is reused
        if !isConfigured {
            setupViews()
            isConfigured = true
        }
    }
    
    private func setupViews(){
        setupCollView()
        setupPageController()

        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        containerView.backgroundColor = AppColors.customGray
        
        containerView.layer.borderColor = AppColors.customGray6.cgColor
        containerView.layer.borderWidth = 2
        
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        collectionView.addSubview(verifiedImg)
        verifiedImg.translatesAutoresizingMaskIntoConstraints = false
        verifiedImg.image = #imageLiteral(resourceName: "guaranteeuz")
        
        containerView.addSubview(pageController)
        pageController.translatesAutoresizingMaskIntoConstraints = false
        pageController.backgroundColor = .clear
        
        containerView.addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.font = .monospacedSystemFont(ofSize: 21, weight: .semibold)
        nameLbl.numberOfLines = 2
        
        containerView.addSubview(priceLbl)
        priceLbl.translatesAutoresizingMaskIntoConstraints = false
        priceLbl.textAlignment = .right
        priceLbl.numberOfLines = 0
        
        containerView.addSubview(locationImg)
        locationImg.translatesAutoresizingMaskIntoConstraints = false
        locationImg.image = #imageLiteral(resourceName: "location")
        
        containerView.addSubview(locationLbl)
        locationLbl.translatesAutoresizingMaskIntoConstraints = false
        locationLbl.numberOfLines = 0
        
        s_vForGuestType.addArrangedSubview(familyImg)
        familyImg.translatesAutoresizingMaskIntoConstraints = false
        familyImg.image = #imageLiteral(resourceName: "1")
        
        s_vForGuestType.addArrangedSubview(womens)
        womens.translatesAutoresizingMaskIntoConstraints = false
        womens.image = #imageLiteral(resourceName: "2")
        
        s_vForGuestType.addArrangedSubview(mans)
        mans.translatesAutoresizingMaskIntoConstraints = false
        mans.image = #imageLiteral(resourceName: "3")
        
        s_vForGuestType.addArrangedSubview(mixImg)
        mixImg.translatesAutoresizingMaskIntoConstraints = false
        mixImg.image = #imageLiteral(resourceName: "4")
        
        containerView.addSubview(s_vForGuestType)
        s_vForGuestType.translatesAutoresizingMaskIntoConstraints = false
        s_vForGuestType.axis = .horizontal
        s_vForGuestType.spacing = 3
        
        s_vForPool.addArrangedSubview(innirPool)
        innirPool.translatesAutoresizingMaskIntoConstraints = false
        innirPool.image = #imageLiteral(resourceName: "34746")
        
        s_vForPool.addArrangedSubview(outerPool)
        outerPool.translatesAutoresizingMaskIntoConstraints = false
        outerPool.image = #imageLiteral(resourceName: "pngwing")
        
        containerView.addSubview(s_vForPool)
        s_vForPool.translatesAutoresizingMaskIntoConstraints = false
        s_vForPool.axis = .horizontal
        s_vForPool.spacing = 3
        
        containerView.addSubview(alcoholImg)
        alcoholImg.translatesAutoresizingMaskIntoConstraints = false
        alcoholImg.image = #imageLiteral(resourceName: "true")
        
        setupConstraints()
        
        for guestType in [familyImg, womens, mans, mixImg] {
            NSLayoutConstraint.activate([
                guestType.heightAnchor.constraint(equalToConstant: 25),
                guestType.widthAnchor.constraint(equalToConstant: 25)
            ])
        }
        
        configureCell()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalToConstant: 215),
            
            verifiedImg.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 0),
            verifiedImg.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            
            pageController.heightAnchor.constraint(equalToConstant: 30),
            pageController.widthAnchor.constraint(equalToConstant: 150),
            pageController.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            pageController.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 170),
            
            nameLbl.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 0),
            nameLbl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            nameLbl.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: -175),
            
            priceLbl.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: -5),
            priceLbl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            priceLbl.leftAnchor.constraint(equalTo: nameLbl.rightAnchor, constant: 10),
            
            locationImg.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 0),
            locationImg.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 5),
            locationImg.widthAnchor.constraint(equalToConstant: 20),
            locationImg.heightAnchor.constraint(equalToConstant: 20),
            
            locationLbl.leftAnchor.constraint(equalTo: locationImg.rightAnchor, constant: 5),
            locationLbl.topAnchor.constraint(equalTo: locationImg.topAnchor, constant: 0),
            
            s_vForGuestType.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 0),
            s_vForGuestType.topAnchor.constraint(equalTo: locationImg.bottomAnchor, constant: 7),
            
            innirPool.heightAnchor.constraint(equalToConstant: 30),
            innirPool.widthAnchor.constraint(equalToConstant: 30),
           
            outerPool.heightAnchor.constraint(equalToConstant: 30),
            outerPool.widthAnchor.constraint(equalToConstant: 30),
            
            s_vForPool.topAnchor.constraint(equalTo: s_vForGuestType.topAnchor, constant: 0),
            s_vForPool.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            alcoholImg.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: 0),
            alcoholImg.topAnchor.constraint(equalTo: locationLbl.bottomAnchor, constant: 0),
            alcoholImg.heightAnchor.constraint(equalToConstant: 40),
            alcoholImg.widthAnchor.constraint(equalToConstant: 40)
        ])

    }
    
    func updateCell(id: Int, name: String, price: (workingDay: Int, weekend: Int), location: String, images: [String]){
        self.id = id
        nameLbl.text = name
        nameLbl.numberOfLines = 0
        priceLbl.text = "\(price.workingDay)/\(price.weekend) \(SetLanguage.setLang(type: .sumLbl))"
        priceLbl.numberOfLines = 0
        locationLbl.text = location
        self.images = images
    }
    
    func setupPageController() {
        sc.translatesAutoresizingMaskIntoConstraints = false
        pageController.addSubview(sc)
        sc.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        
        sc.scp_style = .SCNormal
        sc.set_view(5, current: 0, current_color: .white, disable_color: nil)
    }
    
    func setupCollView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: containerView.frame, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
    }
    
    func configureCell() {
        collectionView.scrollRectToVisible(
            CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height),
            animated: true
        )
        collectionView.reloadData()
    }
    
    func isVerified(v: Bool, alco: Bool, typeId: [Companylist], pool: [Swimmingpool]) {
        
        verifiedImg.isHidden = !v
        alcoholImg.image = UIImage(named: "\(alco)")
        
        var compId = [Int]()
        
        for i in typeId {
            compId.append(i.id)
        }
        
        for i in 1...4 {
            if compId.contains(i) {
                switch i {
                case 1: familyImg.isHidden = false
                case 2: womens.isHidden = false
                case 3: mans.isHidden = false
                case 4: mixImg.isHidden = false
                default: break
                }
            } else {
                switch i {
                case 1: familyImg.isHidden = true
                case 2: womens.isHidden = true
                case 3: mans.isHidden = true
                case 4: mixImg.isHidden = true
                default: break
                }
            }
        }
        
        if pool.isEmpty {
            innirPool.isHidden = true
            outerPool.isHidden = true
        } else if pool.count == 1 {
            if pool[0].nsme == "Yozgi" {
                outerPool.isHidden = false
                innirPool.isHidden = true
            } else {
                innirPool.isHidden = false
                outerPool.isHidden = true
            }
        } else {
            innirPool.isHidden = false
            outerPool.isHidden = false
        }
        
    }

}

extension HomeCVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count >= 5 ? 5 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
        
        cell.imageCont.layer.cornerRadius = 10
        cell.loadImage(url: images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sc.scroll_did(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDelegate?.cellSelected(id: id, images: images, price: price)
    }
}
