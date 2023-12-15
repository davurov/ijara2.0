//
//  All_ImagesVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 09/12/23.
//

import UIKit

class All_ImagesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setImages(_ imgs: [String]){
        images = imgs
    }
    
    private func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
    }
    
}

extension All_ImagesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as? PhotoCVC else { return UICollectionViewCell() }
        
        cell.loadImage(url: images[indexPath.item])
        
        return cell
    }
}

extension All_ImagesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImageDetailVC()
        vc.setImage(images: images, selectedImgIndex: indexPath.item)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let width = UIScreen.main.bounds.width
        
        return CGSize(width: (width-40)/2, height: (width-40)/3)
    }
}

