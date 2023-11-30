//
//  MapTVC.swift
//  ijara
//
//  Created by Abduraxmon on 23/09/23.
//

import UIKit
import MapKit

protocol MapDelegate: AnyObject {
    func mapPressed(lat: Double,long: Double)
}

class MapTVC: UITableViewCell {
    
    static let identifier: String = String(describing: MapTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var locationLbl: UILabel! {
        didSet {
            locationLbl.text = SetLanguage.setLang(type: .locationLbl)
            locationLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        }
    }
    @IBOutlet weak var map: MKMapView!
    var location = (lat: 0.0,long: 0.0)
    
    weak var delegate: MapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ lat: Double, _ long: Double){
        location.lat = lat
        location.long = long
    }
    
    
    func addMapPin (with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        map.addAnnotation(pin)
    }
    
    @IBAction func openMap(_ sender: Any) {
        delegate?.mapPressed(lat: location.lat, long: location.long)
    }
    
    
}
