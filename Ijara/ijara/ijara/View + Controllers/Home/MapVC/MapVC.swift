//
//  MapVC.swift
//  ijara
//
//  Created by Abduraxmon on 07/09/23.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLbl: UILabel!
    
    var direction: Direction = .down
    var childForMapVC: MapChildVC!
    let locationManager = CLLocationManager()
    var didReceiveInitialLocationUpdate = false
    var userDefData = [CountryhouseData]()
    var houseDM : [HouseDM] = [] {
        didSet {
            for i in houseDM {
                putPin(latitude: i.listlocation[0], longitude: i.listlocation[1], name: i.name, id: i.id)
            }
            getCountryHouse(id: "\(houseDM[0].id)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        addChildHomeVC()
        setupDragGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func putPin(latitude: Double, longitude: Double, name: String, id: Int) {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        pin.title = name
        pin.subtitle = "\(id)"
        
        mapView.addAnnotation(pin)
    }
    
    func addChildHomeVC() {
        childForMapVC = MapChildVC(nibName: "MapChildVC", bundle: nil)
        childForMapVC.delegate = self
        self.add(childForMapVC)
        showHomeChildNotRemove(isDraggingMap: false)
    }
    
    func getCountryHouse(id: String) {
        API.getProducts(id: id) { [self] result in
            if let result = result {
                addressLbl.text = result["address"] as? String
                childForMapVC.houseName.text = result["name"] as? String
                childForMapVC.starLbl.text = "\(result["reyting"] as! Int).0"
                for i in houseDM where "\(i.id)" == id {
                    childForMapVC.housePrice.text = "\(i.workingdays)/ \(i.weekends) so'm"
                    childForMapVC.houseCoordinates.latitude = i.listlocation[0]
                    childForMapVC.houseCoordinates.longitude = i.listlocation[1]
                    childForMapVC.images = i.images
                }
            }
        }
    }
    
    func showHomeChildNotRemove(isDraggingMap: Bool = false) {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {[self] t in
            if !isDraggingMap {
                liftChild(height: childForMapVC.partial, child: childForMapVC)
            }else {
                liftChild(height: childForMapVC.full - 50, child: childForMapVC)
            }
            t.invalidate()
        }
    }
    
    // get data from userdefaults
    func getData() {
        if let savedHouse = UserDefaults.standard.object(forKey: Keys.houseData) as? Data {
            let decoder = JSONDecoder()
            if let houses = try? decoder.decode([HouseDM].self , from: savedHouse) {
                houseDM = houses
            }
        }
    }
    
    func setupDragGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMapPan))
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleMapPan(_ sender: UIPanGestureRecognizer) {
        showHomeChildNotRemove(isDraggingMap: true)
        // Dragging has finished
        if sender.state == .ended {
            showHomeChildNotRemove(isDraggingMap: false)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func whereBtnPressed(_ sender: Any) {
        if let userLocation = mapView.userLocation.location?.coordinate {
            let newCenter = CLLocationCoordinate2D(latitude: userLocation.latitude - 0.0027, longitude: userLocation.longitude)
            let region = MKCoordinateRegion(center: newCenter, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            }
    }
    
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            //Create the view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "pin")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if  let anotation = view.annotation {
            UIView.animate(withDuration: 1) {
                view.transform = CGAffineTransform(translationX: 0, y: -40)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.5) {
                    view.transform = .identity
                }
            }
            getCountryHouse(id: anotation.subtitle!!)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
    
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !didReceiveInitialLocationUpdate {
            //let userLocation = location.coordinate
            let userLocation = CLLocationCoordinate2D(latitude: houseDM[0].listlocation[0] - 0.0027, longitude: houseDM[0].listlocation[1])
            let regionSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            
            let region = MKCoordinateRegion(center: userLocation, span: regionSpan)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
            
            didReceiveInitialLocationUpdate = true
        }
    }
}

extension MapVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MapVC: SwipeDelegate {
    func didSwipe(dir: Direction) {
        if dir == .up && dir != direction {
            if screenSize.height / 2 > 400 {
                liftChild(height: 395, child: childForMapVC)
            } else {
                liftChild(height: 200, child: childForMapVC)
            }
            direction = .up
        } else if dir == .down && dir != direction {
            liftChild(height: childForMapVC.partial , child: childForMapVC)
            direction = .down
        }
    }
}
