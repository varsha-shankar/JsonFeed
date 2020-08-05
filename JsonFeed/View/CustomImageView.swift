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
    func loadImageFrom(urlString: String, completionHandler: @escaping (UIImage?) -> Void) {

        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        imageUrl = urlString


        if let cachedImage = ImageCacheManager.shared.getImage(forKey: urlString) {
            completionHandler(cachedImage)
            return
        }

        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let unwrappedError = error {
                    completionHandler(nil)
                    print(unwrappedError)
                    return
                }

                if let unwrappedData = data, let downloadedImage = UIImage(data: unwrappedData) {
                    DispatchQueue.main.async(execute: {
                        ImageCacheManager.shared.save(image: downloadedImage, forKey: urlString)
                        if self.imageUrl == urlString {
                            completionHandler(downloadedImage)
                        }
                    })
                }

            }
            currentTask = dataTask
            dataTask.resume()
        }
    }
}
