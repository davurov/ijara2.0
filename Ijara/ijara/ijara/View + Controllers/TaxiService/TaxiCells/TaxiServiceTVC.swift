//
//  TaxiServiceTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 02/12/23.
//

import UIKit

protocol ShowTaxiDetailProtocol: AnyObject {
    func openTaxiDetail(index: Int)
}

class TaxiServiceTVC: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var carTypeLbl: UILabel!
    
    @IBOutlet weak var passangersLbl: UILabel!
    
    @IBOutlet weak var costLbl: UILabel!
    
    @IBOutlet weak var taxiType: UILabel!
    
    @IBOutlet weak var passangers: UILabel!
    
    @IBOutlet weak var cost: UILabel!
    
    static let identifire: String = String(describing: TaxiServiceTVC.self)
    static func nib() -> UINib { return UINib(nibName: identifire, bundle: nil) }
    
    var carImages: [String] = []
    weak var didTappedDelegate: ShowTaxiDetailProtocol!
    var cellIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.addBorder(size: 2)
        backView.layer.cornerRadius = 15
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .white
        }
    }
    
    func updateCell(carType: String, passangers: String, cost: String, carImages: [String]) {
        taxiType.text = carType
        self.passangers.text = passangers
        self.cost.text = cost
        self.carImages = carImages
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        collectionView.reloadData()
    }
    
    private func setupViews(){
        carTypeLbl.text = SetLanguage.setLang(type: .taxiType)
        passangersLbl.text = SetLanguage.setLang(type: .numberOfPassangers)
        costLbl.text = SetLanguage.setLang(type: .priceLbl)
    }
    
}

extension TaxiServiceTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        carImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as? PhotoCVC else { return UICollectionViewCell() }

        photoCell.loadImage(url: carImages[indexPath.item])
        
        photoCell.imageCont.layer.cornerRadius = 10
        photoCell.imageCont.clipsToBounds = true
        
        photoCell.houseImage.layer.cornerRadius = 10
        photoCell.houseImage.clipsToBounds = true
        
        return photoCell
    }
}

extension TaxiServiceTVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        didTappedDelegate.openTaxiDetail(index: cellIndex)
    }
}

extension TaxiServiceTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }
}
