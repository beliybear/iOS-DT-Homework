//
//  NetworkManager.swift
//  Navigation
//
//  Created by Beliy.Bear on 10.04.2023.
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case peopleURL = "https://swapi.dev/api/people/8"
    case starshipsURL = "https://swapi.dev/api/starships/3"
    case planetsURL = "https://swapi.dev/api/planets/5"
}

struct NetworkManager {
    
    func request(for configuration: AppConfiguration) {
            guard let url = URL(string: configuration.rawValue) else {
                return
            }
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let text = dictionary["url"] as? String
                else {
                    return
                }
                print(text)
                print(response as Any)
                print(error?.localizedDescription as Any)
            }
            task.resume()
        }
}
