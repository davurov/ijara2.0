//
//  ChildrensPartyTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 05/12/23.
//

import UIKit

class ChildrensPartyTVC: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var organizationNameLbl: UILabel!
    
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var likedBtn: UIButton!
    
	static let identifer = String(describing: ChildrensPartyTVC.self)
	static func nib() -> UINib { return UINib(nibName: identifer, bundle: nil) }
	
	var partyID = 0
	
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if selected {
			contentView.backgroundColor = .white
		}
	}
	
    @IBAction func likedBtnPressed(_ sender: Any) {
		let isLiked = LikedProducts.likedProducts.isLikedPerform(sevriceType: .party, id: partyID)
		
		let heartImg = UIImage(systemName: isLiked ? "heart.fill" : "heart")
		
		likedBtn.setImage(heartImg, for: .normal)
    }
    
	func updateCell(_ party: ChildrensParty, heartImage: UIImage){
		img.sd_setImage(with: URL(string: base_URL + (party.images.first ?? "")))
		organizationNameLbl.text = party.title
		priceLbl.text = party.startingprice + " " + SetLanguage.setLang(type: .sumLbl)
		likedBtn.setImage(heartImage, for: .normal)
	}
	
	private func setupViews(){
		img.layer.cornerRadius = 10
		img.clipsToBounds = true
		
		priceView.layer.cornerRadius = 15
		priceView.clipsToBounds = true
		priceView.addShadowCustom(offset: CGSize(width: 5, height: 5), color: AppColors.mainColor.cgColor, radius: 5, opacity: 1)
		
//		let isLiked = LikedProducts.likedProducts.isLiked(sevriceType: .party, id: partyID)
//
//		let heartImg = UIImage(systemName: isLiked ? "heart.fill" : "heart")
//
//		likedBtn.setImage(heartImg, for: .normal)
	}
}
