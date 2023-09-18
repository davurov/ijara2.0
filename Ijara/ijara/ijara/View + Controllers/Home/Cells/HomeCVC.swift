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

protocol CellDelegate {
    func cellSelected(id: String)
}

class HomeCVC: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pirceLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var imageCont: UIView!
    
    @IBOutlet weak var verifiedImg: UIImageView!
    @IBOutlet weak var alcoholImg: UIImageView!
    @IBOutlet weak var onlyFamilyImg: UIImageView!
    @IBOutlet weak var womenImg: UIImageView!
    @IBOutlet weak var menImg: UIImageView!
    @IBOutlet weak var mixImg: UIImageView!
    @IBOutlet weak var innirPool: UIImageView!
    @IBOutlet weak var outerPool: UIImageView!
    
    @IBOutlet weak var pageController: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [String]()
    var id = 0
    var cellDelegate: CellDelegate?
    // Home Cell Identifier
    static let identifier: String = String(describing: HomeCVC.self)
    let sc = SCPageControlView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubviews()
        setupCollView()
        setupPageController()
    }
    
    func setupSubviews() {
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        imageCont.layer.cornerRadius = 10
        imageCont.clipsToBounds = true
        
    }
    
    func setupPageController() {
        sc.frame = CGRect(x: 0, y: 0, width: pageController.frame.width, height: pageController.frame.height)
        
        sc.scp_style = .SCNormal
        sc.set_view(5, current: 0, current_color: .white, disable_color: nil)
        
        pageController.addSubview(sc)
    }
    
    
    
    func setupCollView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
    }
    
    func configureCell() {
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height
                                                 ), animated: true)
        collectionView.reloadData()
    }
    
    func isVerified(v: Bool,
                    alco: Bool,
                    typeId: [Companylist],
                    pool: [Swimmingpool]) {
        
        verifiedImg.isHidden = !v
        alcoholImg.image = UIImage(named: "\(alco)")
        
        var compId = [Int]()
        
        for i in typeId {
            compId.append(i.id)
        }
        
        
        for i in 1...4 {
            if compId.contains(i) {
                switch i {
                case 1: onlyFamilyImg.isHidden = false
                case 2: womenImg.isHidden = false
                case 3: menImg.isHidden = false
                case 4: mixImg.isHidden = false
                default: break
                }
            } else {
                switch i {
                case 1: onlyFamilyImg.isHidden = true
                case 2: womenImg.isHidden = true
                case 3: menImg.isHidden = true
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
        cell.imageCont.layer.cornerRadius = 10
        cell.loadImage(url: images[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sc.scroll_did(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDelegate?.cellSelected(id: "\(id)")
    }
}
