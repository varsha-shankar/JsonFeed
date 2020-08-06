//
//  FactsViewModel.swift
//  JsonFeed
//
//  Created by Varsha Shankar on 31/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import UIKit

typealias JsonFeedCompletionHandler = (RequestStatus) -> Void

enum RequestStatus{
    case NetworkError
    case Success
    case Failure
}

class FactsViewModel {
    
    private var networkWorker = NetworkWorker()
    private var factsData = [Rows]()
    private var title = ""
    
    // MARK: - Method to fetch Rows from Json Feed
    func fetchFactsRows(completion: @escaping JsonFeedCompletionHandler = { _ in }) {

        if !NetworkStatus.sharedInstance.hasConnectivity() {
            self.resetDataSource()
            completion(.NetworkError)
        } else {
            networkWorker.getFactsJsonFeed(urlString: url) { [weak self] (result) in
                switch result {
                case .success(let listOf) :
                    self?.factsData.removeAll()
                    self?.title = listOf.title
                    for row in listOf.rows! {
                        if let _ = row.title {
                            self?.factsData.append(row)
                        }
                    }
                    completion(.Success)
                case .failure(let error):
                    self?.resetDataSource()
                    completion(.Failure)
                    print("Error in getting json feed",error)
                }
            }
        }
    }
    
    // MARK: - Reset Datasource
    func resetDataSource() {
        self.title = ""
        self.factsData.removeAll()
    }
    
    // MARK: - Get Title
    func getTitle() -> String {
        return title
    }
    
    // MARK: - Get Number of Rows
    func numberOfRowsInSection(section: Int) -> Int {
        if factsData.count != 0 {
            return factsData.count
        }
        return 0
    }
    
    // MARK: - Set Data for Cell
    func cellForRowAt (indexPath: IndexPath) -> Rows {
        return factsData[indexPath.row]
    }
    
}
