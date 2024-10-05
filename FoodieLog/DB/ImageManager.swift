//
//  ImageManager.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/30/24.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    func saveImageToDisk(image: UIImage, imageName: String) -> String? {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let fileName = "\(imageName).jpg"
            let path = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                try data.write(to: path)
                return fileName
            } catch {
                print("Failed to save image: \(error)")
                return nil
            }
        }
        return nil
    }

    func loadImageFromDisk(imageName: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent(imageName)
        return UIImage(contentsOfFile: path.path)
    }
    func loadImagesFromDisk(imageNames: [String]) -> [UIImage] {
            var images: [UIImage] = []
            
            for imageName in imageNames {
                if let image = loadImageFromDisk(imageName: imageName) {
                    images.append(image)
                } else {
                    print("Failed to load image: \(imageName)")
                }
            }
            
            return images
        }
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    func deleteImageFromDisk(imageName: String) {
            let fileManager = FileManager.default
            if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent(imageName)
                do {
                    try fileManager.removeItem(at: fileURL)
                    print("Image deleted successfully: \(imageName)")
                } catch {
                    print("Error deleting image: \(error)")
                }
            }
        }
}
