//
//  ChildrensServiceDetailVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 05/12/23.
//

import UIKit

class ChildrensServiceDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var callBtn: UIButton!
    
	var likeBtn: UIBarButtonItem!
    
    //MARK: Variables
	var party: ChildrensParty!
	let screenWidth = UIScreen.main.bounds.width
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = false
		navigationController?.navigationBar.isHidden = false
		title = party.title
		
		setupTableView()
		setupViews()
		setupTabbarButtons()
		priceLbl.text = party.startingprice + " " + SetLanguage.setLang(type: .sumLbl)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.navigationBar.isHidden = false
	}
	
    @IBAction func callBtnPressed(_ sender: Any) {
		party.firstphone.callNumber()
    }
    
	@objc func likeBtnPressed(){
		let isLiked = LikedProducts.likedProducts.isLikedPerform(sevriceType: .party, id: party.id)
		
		likeBtn.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
	}
	
	@objc func shareBtnPressed(){
		shareRoute()
	}
	
	
	func setValues(_ party: ChildrensParty){
		self.party = party
	}
	
	private func setupTableView(){
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(PartyImagesTVC.nib(), forCellReuseIdentifier: PartyImagesTVC.identifier)
		tableView.register(ChildrensAdditionalInfoTVC.nib(), forCellReuseIdentifier: ChildrensAdditionalInfoTVC.identifier)
		tableView.register(DriverInfoTVC.nib(), forCellReuseIdentifier: DriverInfoTVC.identifier)
	}
	
	private func setupViews() {
		bottomView.backgroundColor = .white
		bottomView.layer.shadowColor = AppColors.customBlack.cgColor
		bottomView.layer.shadowOpacity = 0.3
		bottomView.layer.shadowRadius = 5
		bottomView.layer.shadowOffset = CGSize(width: 0, height: 0)
		bottomView.layer.cornerRadius = 20
		bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
		
		callBtn.backgroundColor = AppColors.mainColor
		callBtn.setTitleColor(.white, for: .normal)
		callBtn.setTitle(SetLanguage.setLang(type: .callBtn), for: .normal)
		callBtn.layer.cornerRadius = 10
		callBtn.clipsToBounds = true
	}
	
	private func setupTabbarButtons(){
		likeBtn = UIBarButtonItem(
			image: UIImage(systemName: "heart"), style: .done,
			target: self, action: #selector(likeBtnPressed)
		)
		
		//find that party is liked
		let isLiked = LikedProducts.likedProducts.isLiked(sevriceType: .party, id: party.id)
		
		likeBtn.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")

		
		likeBtn.tintColor = AppColors.mainColor
		
		let shareBtn = UIBarButtonItem(
			image: UIImage(systemName: "square.and.arrow.up"), style: .done,
			target: self, action: #selector(shareBtnPressed)
		)
		
		shareBtn.tintColor = AppColors.mainColor
		
		navigationItem.rightBarButtonItems = [likeBtn, shareBtn]
	}
	
	func shareRoute(){
		let text = "https://bronla.uz/forchildren"
		let shareAll: [Any] = [text]
		let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	
}

extension ChildrensServiceDetailVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			guard let photoCell = tableView.dequeueReusableCell(withIdentifier: PartyImagesTVC.identifier, for: indexPath) as? PartyImagesTVC else { return UITableViewCell() }
			
			photoCell.updateCell(images: party.images)
			photoCell.allImagesDelegate = self
			photoCell.backgroundColor = .clear
			
			return photoCell
		} else if indexPath.row == 1 {
			guard let additionalCell = tableView.dequeueReusableCell(withIdentifier: ChildrensAdditionalInfoTVC.identifier, for: indexPath) as? ChildrensAdditionalInfoTVC else { return UITableViewCell() }
			
			additionalCell.updateCell(party)
			additionalCell.backgroundColor = .clear
			
			return additionalCell
		} else {
			guard let commentCell = tableView.dequeueReusableCell(withIdentifier: DriverInfoTVC.identifier, for: indexPath) as? DriverInfoTVC else { return UITableViewCell() }
			
			commentCell.setValues(taxi: TaxiDM(
				id: party.id,
				title: "",
				taxiType: "",
				taxiDirection: "",
				passengers: "",
				startingPrice: "",
				carImages: [],
				driverName: party.owner,
				coments: party.comment,
				telNumber1: party.firstphone,
				telNumber2: party.secondphone,
				minimumConditions: ""
			))
			commentCell.backgroundColor = .clear
			
			return commentCell

		}
	}
}

extension ChildrensServiceDetailVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return ((screenWidth-40)/3)*2 + 65
		} else {
			return UITableView.automaticDimension
		}
	}
	
}

extension ChildrensServiceDetailVC: AllImagesProtocol {
	func allPressed(_ images: [String]) {
		let vc = All_ImagesVC()
		vc.setImages(party.images)
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func detailPressed(images: [String], selectedImageIndex: Int) {
		let vc = ImageDetailVC()
		vc.setImage(images: images, selectedImgIndex: selectedImageIndex)
		navigationController?.pushViewController(vc, animated: true)
	}
}
