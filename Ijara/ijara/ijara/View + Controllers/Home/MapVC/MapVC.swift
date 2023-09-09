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
    
    var childForMapVC: MapChildVC!
    let locationManager = CLLocationManager()
    var didReceiveInitialLocationUpdate = false
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
        self.add(childForMapVC)
        showHomeChildNotRemove(isDraggingMap: false)
    }
    
    func getCountryHouse(id: String) {
        API.getProducts(id: id) { [self] result in
            if let result = result {
                addressLbl.text = result.address
            }
        }
    }
    
    func placeBtnPressed() {
        //        let cameraPosition = GMSCameraPosition.camera(withLatitude: mapView.myLocation?.coordinate.latitude ?? 0, longitude: mapView.myLocation?.coordinate.longitude ?? 0, zoom: 17.0)
        //        mapView.animate(to: cameraPosition)
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
        if !didReceiveInitialLocationUpdate, let location = locations.last {
            //let userLocation = location.coordinate
            let userLocation = CLLocationCoordinate2D(latitude: houseDM[0].listlocation[0], longitude: houseDM[0].listlocation[1])
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
