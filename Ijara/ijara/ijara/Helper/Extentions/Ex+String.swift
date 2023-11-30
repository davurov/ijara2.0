//
//  File.swift
//  ijara
//
//  Created by Abduraxmon on 15/08/23.
//

import Foundation
import UIKit

extension String {
    func callNumber() {
        if let phoneCallURL = URL(string: "tel://\(self)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}


