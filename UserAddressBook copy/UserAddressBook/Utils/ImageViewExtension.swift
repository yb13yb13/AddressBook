//
//  ImageViewExtension.swift
//  UserAddressBook
//
//  Created by Youcef B on 5/19/22.
//

import UIKit

/**
 Image caching
 */
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    /// Make image circular
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    /**
     This method caches images  so it's not flickering when scrolling for example in the list of contacts
     */
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // otherwise fire off a new download
        let url = URL(string: urlString)
        guard let thisURL = url else {
            print(NSError.description())
            return
            
        }
        URLSession.shared.dataTask(with: thisURL, completionHandler: { (data, response, error) in
            // download hit an error so lets return out
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}
