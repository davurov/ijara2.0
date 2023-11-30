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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }

    func setupMap(){
        let locationCoordinate = CLLocationCoordinate2D(latitude: 41.274219, longitude: 69.313341)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)

        let region = MKCoordinateRegion(
            center: locationCoordinate,
            span: span
        )
        
        companyLocationMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "Company location"
        
        companyLocationMap.addAnnotation(annotation)
    }

    
}
