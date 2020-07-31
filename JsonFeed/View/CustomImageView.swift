//
//  CustomImageView.swift
//  JsonFeed
//
//  Created by Shankar, Varsha on 8/1/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {

    private var currentTask: URLSessionTask?
    var imageUrl: String?

    // MARK: - Load Image from Url
    func loadImageFrom(urlString: String) {

        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        imageUrl = urlString

        image = nil

        if let cachedImage = ImageCacheManager.shared.getImage(forKey: urlString) {
            image = cachedImage
            return
        }

        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let unwrappedError = error {
                    print(unwrappedError)
                    return
                }

                if let unwrappedData = data, let downloadedImage = UIImage(data: unwrappedData) {
                    DispatchQueue.main.async(execute: {
                        ImageCacheManager.shared.save(image: downloadedImage, forKey: urlString)
                        if self.imageUrl == urlString {
                            self.image = downloadedImage
                        }
                    })
                }

            }
            currentTask = dataTask
            dataTask.resume()
        }
    }
}
