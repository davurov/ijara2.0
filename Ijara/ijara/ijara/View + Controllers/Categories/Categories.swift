//
//  Categories.swift
//  ijara
//
//  Created by Sarvar Qosimov on 05/12/23.
//

import UIKit

class Categories: UIViewController {
    
    @IBOutlet weak var housesView: UIView!
    
    @IBOutlet weak var childrensView: UIView!
    
    @IBOutlet weak var taxisView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(housesView)
        setupView(childrensView)
        setupView(taxisView)
        
        
    }
    
    func setupView(_ v: UIView) {
      // Set up the circular shape
        v.layer.cornerRadius = v.bounds.width / 2
        v.layer.masksToBounds = false
      
      // Set up the shadow
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4
      
      // Ensure the shadow follows the circular shape
        v.layer.shadowPath = UIBezierPath(ovalIn: v.bounds).cgPath
       
  }
    
    
    
    
}

      

//private func setupView() {
//    // Set up the circular shape
//    housesView.layer.cornerRadius = housesView.bounds.width / 2
//    housesView.layer.masksToBounds = false
//
//    // Set up the shadow
//    housesView.layer.shadowColor = UIColor.black.cgColor
//    housesView.layer.shadowOpacity = 0.5
//    housesView.layer.shadowOffset = CGSize(width: 0, height: 2)
//    housesView.layer.shadowRadius = 4
//
//    // Ensure the shadow follows the circular shape
//    housesView.layer.shadowPath = UIBezierPath(ovalIn: bounds).cgPath
//}
