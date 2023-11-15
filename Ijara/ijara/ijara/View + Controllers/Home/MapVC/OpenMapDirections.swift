//
//  OpenMapDirections.swift
//  ijara
//
//  Created by Abduraxmon on 11/09/23.
//
import CoreLocation
import MapKit
import UIKit

class OpenMapDirections {
    // If you are calling the coordinate from a Model, don't forgot to pass it in the function parenthesis.
    static func present(in viewController: UIViewController, latitude: Double, longitude:Double, sourceView: UIView) {
        let coordinates = "\(latitude),\(longitude)"
        let actionSheet = UIAlertController(title: SetLanguage.setLang(type: .openLocation), message: SetLanguage.setLang(type: .openLocationMessage), preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
            // Pass the coordinate inside this URL
            if let url = URL(string: "comgooglemaps://?q=\(coordinates)") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // If Google Maps is not installed, open the location in Safari
                    let safariURL = URL(string: "https://www.google.com/maps?q=\(coordinates)")!
                    UIApplication.shared.open(safariURL, options: [:], completionHandler: nil)
                }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
            // Pass the coordinate that you want here
            let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = "Destination"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }))
        actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
        actionSheet.popoverPresentationController?.sourceView = sourceView
        actionSheet.addAction(UIAlertAction(title: SetLanguage.setLang(type: .cancelTitle), style: .cancel, handler: nil))
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}
