//
//  ImageDetailVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 09/12/23.
//

import UIKit

class ImageDetailVC: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    var imagesURL: [String] = []
    var currentImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img.sd_setImage(with: URL(string: base_URL + imagesURL[currentImageIndex]))
        
        let leftSwiped = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLeft(_:)))
        let rightSwiped = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRight(_:)))
        
        img.isUserInteractionEnabled = true

        leftSwiped.direction = .left
        rightSwiped.direction = .right
        
        img.addGestureRecognizer(leftSwiped)
        img.addGestureRecognizer(rightSwiped)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func xPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func previousPressed(_ sender: Any) {
        previousImage()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
       nextImage()
    }
    
    @objc func swipeToLeft(_ sender: Any){
        print("left")
        nextImage()
    }
   
    @objc func swipeToRight(_ sender: Any){
        print("right")
        previousImage()
    }
    
    func setImage(images: [String], selectedImgIndex: Int){
       imagesURL = images
        currentImageIndex = selectedImgIndex
    }
    
    func previousImage(){
        if currentImageIndex-1 >= 0 {
            currentImageIndex -= 1
            img.sd_setImage(with: URL(string: base_URL + imagesURL[currentImageIndex]))
        }
    }
    
    func nextImage(){
        if currentImageIndex+1 <= imagesURL.count-1 {
            currentImageIndex += 1
            img.sd_setImage(with: URL(string: base_URL + imagesURL[currentImageIndex]))
        }
    }
    
}
