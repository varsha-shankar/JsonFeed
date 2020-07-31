//
//  NetworkWorker.swift
//  JsonFeed
//
//  Created by Varsha Shankar on 31/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import Foundation

class NetworkWorker {
    
    private var dataTask: URLSessionDataTask?
    
    func getFactsJsonFeed(completion: @escaping (Result<Facts, Error>) -> Void) {
       
        let requestURLString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        guard let url = URL(string: requestURLString) else { return }
        dataTask = URLSession.shared.dataTask(with: url) { (data,response,error) in
            
            //Handle error
            if let error = error {
                completion(.failure(error))
                print("Datatask error: \(error.localizedDescription)")
                return
            }
            
       guard let response = response as? HTTPURLResponse else {
            // Handle Empty Response
            print("Empty Response")
            return
        }
        print("Response status code: \(response.statusCode)")
            
        guard let data = data else { return }
        guard let dataInString = String(data:data,encoding: String.Encoding.isoLatin1) else { return }
        guard let properData = dataInString.data(using: .utf8, allowLossyConversion: true) else { return }
            
                do {
                    let jsonData = try JSONDecoder().decode(Facts.self, from: properData)
                    
                    //Main Thread Operation
                    DispatchQueue.main.async {
                        completion(.success(jsonData))
                    }
                } catch let error {
                    completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
}
