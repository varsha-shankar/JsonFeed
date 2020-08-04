//
//  NetworkStatus.swift
//  JsonFeed
//
//  Created by Shankar, Varsha on 8/5/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

class NetworkStatus: NSObject {

    static let sharedInstance = NetworkStatus()

    //Function to check that if wifi is enabled and connected to any ssid or not
    func hasConnectivity() -> Bool {

        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0

    }

}

