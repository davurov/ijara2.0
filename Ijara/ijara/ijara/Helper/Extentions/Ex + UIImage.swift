//
//  Ex + UIImage.swift
//  ijara
//
//  Created by Muslim on 01/09/23.
//

import UIKit

extension UIImage {
    func withSize(scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    
    func saveImage() {
        guard let data = self.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: Keys.userImage)
    }
    
    func loadImage() -> UIImage? {
        guard let data = UserDefaults.standard.data(forKey: Keys.userImage) else { return nil}
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded)
        return image
    }
    
    func isEqualToImage(_ image: UIImage) -> Bool {
        let data1 = self.pngData()
        let data2 = image.pngData()
        return data1 == data2
    }
    
}
