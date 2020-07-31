//
//  ImageCacheManager.swift
//  JsonFeed
//
//  Created by Shankar, Varsha on 8/1/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheManager {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!

    static let shared = ImageCacheManager()

    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil, queue: nil) { [weak self] notification in
                self?.cache.removeAllObjects()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }

    // MARK: - Get Image for url key
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    // MARK: - Save Image for url key
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
