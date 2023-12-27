//
//  CompanyLocationDetail.swift
//  IjaraSarvar
//
//  Created by Sarvar Qosimov on 11/09/23.
//

import UIKit
import MapKit

class CompanyLocationDetailVC: UIViewController {
    
    @IBOutlet weak var companyLocationMap: MKMapView!
    
    @IBOutlet weak var adressLbl: UILabel!
    
    @IBOutlet weak var openYMButton: UIButton!
    
    @IBOutlet weak var mainStackBottomCons: NSLayoutConstraint!
    
    static let identifire = String(describing: CompanyLocationDetailVC.self)
    static func nib() -> UINib { UINib(nibName: identifire, bundle: nil) }
    
    var latitude: Double = 0
    var longitude: Double = 0
    var isWithYandexMap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        openYMButton.setTitle(SetLanguage.setLang(type: .openYandexMap), for: .normal)
    }
    
    @IBAction func openYMPressed(_ sender: Any) {
        openYandexMapWithCoordinates(latitude: latitude, longitude: longitude)
    }
    
    func openYandexMapWithCoordinates(latitude: Double, longitude: Double) {
        // Yandex Maps URL scheme
        let yandexMapsURLString = "yandexmaps://maps.yandex.com/?ll=\(longitude),\(latitude)&z=12"
        
        if let yandexMapsURL = URL(string: yandexMapsURLString), UIApplication.shared.canOpenURL(yandexMapsURL) {
            // Open Yandex Maps
            UIApplication.shared.open(yandexMapsURL, options: [:], completionHandler: nil)
        } else {
            // Yandex Maps app is not installed, open Yandex Maps in Safari
            let yandexMapsWebURLString = "https://maps.yandex.com/?ll=\(longitude),\(latitude)&z=12"
            if let yandexMapsWebURL = URL(string: yandexMapsWebURLString) {
                UIApplication.shared.open(yandexMapsWebURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func setupMap(){
        let locationCoordinate = CLLocationCoordinate2D(latitude: 41.274219, longitude: 69.313341)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        self.latitude = 41.274219
        self.longitude = 69.313341
        
        let region = MKCoordinateRegion(
            center: locationCoordinate,
            span: span
        )
        
        companyLocationMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = SetLanguage.setLang(type: .companyLocation)
        
        companyLocationMap.addAnnotation(annotation)
        
        adressLbl.isHidden = isWithYandexMap ? false : true
        openYMButton.isHidden = isWithYandexMap ? false : true
        
        mainStackBottomCons.constant = isWithYandexMap ? 15 : -15
    }

    
}
