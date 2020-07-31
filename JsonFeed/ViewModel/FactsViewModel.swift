//
//  FactsViewModel.swift
//  JsonFeed
//
//  Created by Varsha Shankar on 31/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import UIKit

class FactsViewModel {
    
    private var networkWorker = NetworkWorker()
    private var factsData = [Rows]()
    
    func fetchFactsRows(completion: @escaping () -> ()) {
        
        networkWorker.getFactsJsonFeed { [weak self] (result) in
            
            switch result {
            case .success(let listOf) :
                for row in listOf.rows! {
                    if let _ = row.title {
                        self?.factsData.append(row)
                    }
                }
                completion()
            case .failure(let error):
                print("error",error)
            }
            
        }
        
    }
    
       
       func numberOfRowsInSection(section: Int) -> Int {
           if factsData.count != 0 {
               return factsData.count
           }
           return 0
       }
       
       func cellForRowAt (indexPath: IndexPath) -> Rows {
           return factsData[indexPath.row]
       }

}
