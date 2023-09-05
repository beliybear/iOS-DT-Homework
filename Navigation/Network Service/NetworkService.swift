//
//  NetworkService.swift
//  Navigation
//
//  Created by Ian Belyakov on 13.08.2023
//

import Foundation

protocol NetworkServiceProtocol {
    func titleRequest(completion: @escaping (String) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func titleRequest(completion: @escaping (String) -> Void) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/3") else {
            completion("")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion("")
                }
                return
            }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let titleText = dictionary!["title"] as? String
                DispatchQueue.main.async {
                    completion(titleText!)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }

}
