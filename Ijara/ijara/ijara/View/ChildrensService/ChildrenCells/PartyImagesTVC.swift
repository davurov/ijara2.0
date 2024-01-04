//
//  PartyImagesTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 05/12/23.
//

import UIKit

class PartyImagesTVC: UITableViewCell {
	
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var colViewHeight: NSLayoutConstraint!
    
	@IBOutlet weak var imagesBtn: UIButton!
	
	static let identifier: String = String(describing: PartyImagesTVC.self)
	static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
	
    var partyImages: [String] = []
	let width = UIScreen.main.bounds.width
	weak var allImagesDelegate: AllImagesProtocol!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
	@IBAction func imagesBtnPressed(_ sender: Any) {
		allImagesDelegate.allPressed(partyImages)
	}
	
	func updateCell(images: [String]){
		partyImages = images
	}
	
	private func setupCollectionView(){
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
		
		colViewHeight.constant = ((width-40)/3)*2 + 15
		imagesBtn.setTitle(SetLanguage.setLang(type: .images), for: .normal)
	}
	
}

extension PartyImagesTVC: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		partyImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as? PhotoCVC else { return UICollectionViewCell() }
		
		cell.loadImage(url: partyImages[indexPath.item])
		cell.isWithRadius = true
		cell.giveRadius(10)
		
		return cell
	}
}

extension PartyImagesTVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		allImagesDelegate.detailPressed(images: partyImages, selectedImageIndex: indexPath.item)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: (width-40)/2, height: (width-40)/3)
	}
}
