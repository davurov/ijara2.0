//
//  TaxiDetailVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 03/12/23.
//

import UIKit

class TaxiDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var likeBtn: UIBarButtonItem!
    
        //MARK: Variables
    var taxi: TaxiDM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = taxi.title
        setupTableView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        setupTabbarButtons()
    }
    
    @IBAction func callBtnPressed(_ sender: Any) {
        taxi.telNumber1.callNumber()
    }
    
    @objc func likeBtnPressed(){
        // liked or unliked
        let isLiked = LikedProducts.likedProducts.isLikedPerform(sevriceType: .taxi, id: taxi.id)
        
        likeBtn.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")

//        if isLiked {
//            likeBtn.image = UIImage(systemName: "heart.fill")
//        } else {
//            likeBtn.image = UIImage(systemName: "heart")
//        }
        
//        if likedHouses.contains(id) {
//            let index = likedHouses.firstIndex(of: id) ?? 0
//            likedHouses.remove(at: index)
//            likedDates.remove(at: index)
//            likeBtn.image = UIImage(systemName: "heart")
//        } else {
//            likedHouses.append(id)
//            likedDates.append(getCurrentDateAsString())
//            likeBtn.image = UIImage(systemName: "heart.fill")
//        }
//        UserDefaults.standard.set(likedHouses, forKey: Keys.likedHouses)
//        UserDefaults.standard.set(likedDates, forKey: Keys.likedDate)
    }
    
    @objc func shareBtnPressed(){
        shareRoute()
    }
    
    //MARK: Functions
    func setValues(taxi: TaxiDM){
        self.taxi = taxi
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTVC.nib(), forCellReuseIdentifier: PhotoTVC.identifier)
        tableView.register(TaxiCarInfoTVC.nib(), forCellReuseIdentifier: TaxiCarInfoTVC.identifier)
        tableView.register(DriverInfoTVC.nib(), forCellReuseIdentifier: DriverInfoTVC.identifier)
    }
    
    private func setupViews(){
        bottomView.layer.shadowColor = AppColors.customBlack.cgColor
        bottomView.layer.shadowOpacity = 0.3
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomView.layer.cornerRadius = 20
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]

        
        priceLbl.text = "\(taxi.startingPrice) \(SetLanguage.setLang(type: .sumLbl))"
        
        callBtn.backgroundColor = AppColors.mainColor
        callBtn.layer.cornerRadius = 10
        callBtn.clipsToBounds = true
        callBtn.setTitleColor(.white, for: .normal)
        callBtn.setTitle(SetLanguage.setLang(type: .callBtn), for: .normal)
    }
    
    private func setupTabbarButtons(){
        likeBtn = UIBarButtonItem(
            image: UIImage(systemName: "heart"), style: .done,
            target: self, action: #selector(likeBtnPressed)
        )
        
        //find ...
        let isLiked = LikedProducts.likedProducts.isLiked(sevriceType: .taxi, id: taxi.id)
        
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
        let text = "https://bronla.uz/taxi"
        let shareAll: [Any] = [text]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}

//MARK: UITableViewDataSource
extension TaxiDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotoTVC.identifier, for: indexPath) as? PhotoTVC else { return UITableViewCell() }
            
            photoCell.updateCell(taxi.carImages)
            photoCell.allImagesDelegate = self
            
            return photoCell
        } else if indexPath.row == 1 {
            guard let carInfo = tableView.dequeueReusableCell(withIdentifier: TaxiCarInfoTVC.identifier, for: indexPath) as? TaxiCarInfoTVC else { return UITableViewCell() }
            
            carInfo.updateCell(
                taxiType: taxi.taxiType,
                direction: taxi.taxiDirection,
                passangers: taxi.passengers,
                minimumConditions: taxi.minimumConditions
            )
            
            return carInfo
        } else if indexPath.row == 2 {
            
            guard let driverInfoCel = tableView.dequeueReusableCell(withIdentifier: DriverInfoTVC.identifier, for: indexPath) as? DriverInfoTVC else { return UITableViewCell() }
            
            driverInfoCel.setValues(taxi: taxi)
            
            return driverInfoCel
        }
        
        return UITableViewCell()
        
    }
}
//MARK: UITableViewDelegate
extension TaxiDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else if indexPath.row == 1 {
            return 230
        } else {
            return 300
        }
    }
}

extension TaxiDetailVC: AllImagesProtocol {
    func allPressed(_ images: [String]) {
        let vc = All_ImagesVC()
        vc.setImages(taxi.carImages)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func detailPressed(images: [String], selectedImageIndex: Int) {
        let vc = ImageDetailVC()
        vc.setImage(images: images, selectedImgIndex: selectedImageIndex)
        navigationController?.pushViewController(vc, animated: true)
    }
}
