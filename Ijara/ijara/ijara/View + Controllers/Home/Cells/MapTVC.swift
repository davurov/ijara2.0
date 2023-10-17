//
//  MapTVC.swift
//  ijara
//
//  Created by Abduraxmon on 23/09/23.
//

import UIKit
import MapKit

protocol MapDelegate {
    func mapPressed(lat: Double,long: Double)
}

class MapTVC: UITableViewCell {
    
    static let identifier: String = String(describing: MapTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    
    @IBOutlet weak var locationLbl: UILabel! {
        didSet {
            locationLbl.text = SetLanguage.setLang(type: .locationLbl)
        }
    }
    @IBOutlet weak var map: MKMapView!
    var location = (lat: 0.0,long: 0.0)
    
    var delegate: MapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
