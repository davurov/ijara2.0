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
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var addressLbl: UILabel!
    
    //MARK: Variables
    
    var direction: Direction = .down
    var childForMapVC: MapChildVC!
    weak var locationManager: CLLocationManager? {
        return CLLocationManager()
    }
    var didReceiveInitialLocationUpdate = false
    var likedHouses: [Int] = {
        return UserDefaults.standard.array(forKey: Keys.likedHouses) as? [Int] ?? []
    }()
    var allHouses: [CountryhouseData] = []
    var price = (weekday: 0, working:0)
    var idOfHouseForChild = 1
    
    var isConfigured = false
    
    //MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLbl.text = SetLanguage.setLang(type: .looking)
        getCountryHouse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear in mapVC")
        likedHouses = UserDefaults.standard.array(forKey: Keys.likedHouses) as? [Int] ?? []
        
        if !isConfigured {
            addChildHomeVC()
            childForMapVC.view.isHidden = true
            isConfigured = true
        }
        
        checkIsLikedForMapChildVC(idOfHouseForChild)
    }
    
    deinit {
        print("deinit map vc")
    }
    
    //MARK: functions
    
    func setupMap() {
        guard let mapView = mapView else { return }
        mapView.showsUserLocation = true
        
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    /// func will put pins to all locations of houses
    func putPin(latitude: Double, longitude: Double, name: String, id: Int) {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pin.title = name
        pin.subtitle = "\(id)"
        
        guard let mapView = mapView else { return }
        mapView.addAnnotation(pin)
    }
    
    func addChildHomeVC() {
        print("addChildHomeVC")
        childForMapVC = MapChildVC(nibName: "MapChildVC", bundle: nil)
        childForMapVC.delegate = self
        self.add(childForMapVC)
        
        showHomeChildNotRemove(isDraggingMap: false)
    }
    
    /// `getCountryHouse` func get all houses from API
    func getCountryHouse() {
        API.getAllHouses { [weak self] allHouses in
            guard let strongSelf = self else { return }

            guard let allHouses = allHouses else { return }

            guard let mapView = strongSelf.mapView else { return }

            guard let locationManager = strongSelf.locationManager else { return }
            
            strongSelf.allHouses = allHouses
            
            API.isMap = true
            strongSelf.setupMap()
//            strongSelf.addChildHomeVC()
            strongSelf.setupDragGestureRecognizer()
            mapView.delegate = self
            locationManager.delegate = self
            
            if allHouses.count != 0 {
                strongSelf.idOfHouseForChild = allHouses.first!.id
                strongSelf.setPinsAndRegion()
                strongSelf.updateChildMapView(allHouses.first!.id)
            }
            strongSelf.childForMapVC.view.isHidden = false
        }
    }
    
    /// update data of child VC when user select other pin
    func updateChildMapView(_ idOfChildMap: Int){
        API.getDetailDataByID(id: idOfChildMap) { [self] villa in
            guard let house = villa else { return }
            guard let childForMapVC = childForMapVC else { return }
            
            //set up child map vc data
            addressLbl.text = house.address
            childForMapVC.houseName.text = house.name
            childForMapVC.starLbl.text = "\(house.reyting)"
            childForMapVC.housePrice.text = "\(house.priceForWorkingDays)/ \(house.priceForWeekends) \(SetLanguage.setLang(type: .sumLbl))"
            childForMapVC.houseCoordinates.latitude = house.listlocation[0]
            childForMapVC.houseCoordinates.longitude = house.listlocation[1]
            childForMapVC.images = house.images
            childForMapVC.id = idOfChildMap
            price.weekday = house.priceForWeekends
            price.working = house.priceForWorkingDays
            // check if the house liked or not
            
            checkIsLikedForMapChildVC(idOfChildMap)
           
        }
    }
    
    func showHomeChildNotRemove(isDraggingMap: Bool = false) {
        guard let childForMapVC = childForMapVC else { return }

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {[weak self] t in
            guard let strongSelf = self else { return }
            
            if !isDraggingMap {
                strongSelf.liftChild(height: childForMapVC.partial, child: childForMapVC)
            } else {
                strongSelf.liftChild(height: childForMapVC.full - 50, child: childForMapVC)
            }
            t.invalidate()
        }
    }
        
    func checkIsLikedForMapChildVC(_ idOfChildMap: Int){
        if likedHouses.contains(idOfChildMap) {
            childForMapVC.likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            childForMapVC.likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func setPinsAndRegion(){
        // put pin to houses location
        allHouses.forEach { house in
            putPin(
                latitude: house.listlocation[0],
                longitude: house.listlocation[1],
                name: house.name,
                id: house.id
            )
        }
        
        // default location of user
        
        guard allHouses.first != nil else { return }
        
        let cordinate = allHouses.first!.listlocation
        
        let clLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: cordinate[0],
            longitude: cordinate[1]
        )
        
        let mkCoordinateRegion = MKCoordinateRegion(
            center: clLocationCoordinate2D,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
        
        guard let mapView = mapView else { return }
        
        mapView.setRegion(mkCoordinateRegion, animated: true)
    }
    
    func setupDragGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMapPan))
        panGesture.delegate = self
        
        guard let mapView = mapView else { return }
        
        mapView.addGestureRecognizer(panGesture)
    }
    
    //MARK: @objc functions
    
    @objc private func handleMapPan(_ sender: UIPanGestureRecognizer) {
        showHomeChildNotRemove(isDraggingMap: true)
        // Dragging has finished
        if sender.state == .ended {
            showHomeChildNotRemove(isDraggingMap: false)
        }
    }

    //MARK: @IBAction functions

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func whereBtnPressed(_ sender: Any) {
        
        guard let mapView = mapView else { return }
        
        if let userLocation = mapView.userLocation.location?.coordinate {
            let newCenter = CLLocationCoordinate2D(latitude: userLocation.latitude - 0.0027, longitude: userLocation.longitude)
            let region = MKCoordinateRegion(center: newCenter, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
}

//MARK: MKMapViewDelegate
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
        if let anotation = view.annotation {
            UIView.animate(withDuration: 1) {
                view.transform = CGAffineTransform(translationX: 0, y: -40)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.5) {
                    view.transform = .identity
                }
            }
                
            guard let optionalSubtitle = anotation.subtitle else { return }
            guard let subtitle = optionalSubtitle else { return }
            guard let subtitleToInt = Int(subtitle) else { return }
            
            idOfHouseForChild = subtitleToInt
            updateChildMapView(subtitleToInt)
        }
    }
    
}

//MARK: CLLocationManagerDelegate
extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationManager = locationManager else { return }
        
        guard let mapView = mapView else { return }
        
        if !didReceiveInitialLocationUpdate {
            
            let userLocation = CLLocationCoordinate2D(
                latitude: allHouses[0].listlocation[0] - 0.0027,
                longitude: allHouses[0].listlocation[1]
            )
            
            let regionSpan = MKCoordinateSpan(
                latitudeDelta: 0.2,
                longitudeDelta: 0.2
            )
            
            let region = MKCoordinateRegion(center: userLocation, span: regionSpan)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
            
            didReceiveInitialLocationUpdate = true
        }
    }
}

//MARK: UIGestureRecognizerDelegate
extension MapVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: MapChildDelegate
extension MapVC: MapChildDelegate {
    func moreInfoPressed(id: Int, images: [String]) {
        print("\(id) from moreInfo")
        let vc = HomeDetailVC()
        vc.getData(id: id)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        vc.images = images
        vc.id = id
        vc.price.weekday = price.weekday
        vc.price.wrking = price.working
    }
    
    func didSwipe(dir: Direction) {
        guard let childForMapVC = childForMapVC else { return }

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
