//
//  NetworkManager.swift
//  Navigation
//
//  Created by Beliy.Bear on 10.04.2023.
//

import Foundation

// Задание 1

enum AppConfiguration: String, CaseIterable {
    case peopleURL = "https://swapi.dev/api/people/8"
    case starshipsURL = "https://swapi.dev/api/starships/3"
    case planetsURL = "https://swapi.dev/api/planets/5"
}

// Задание 2.1

struct Data: Codable {
    let userId, id: Int
    let title: String
    let completed: Bool
}

// Задание 2.2

struct Planet: Codable {
    let name, rotationPeriod, orbitalPeriod, diameter: String
    let climate, gravity, terrain, surfaceWater, population: String
    let created, edited: String
    let residents, films: [String]
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter, climate, gravity, terrain
        case surfaceWater = "surface_water"
        case population, residents, films, created, edited, url
    }
}

struct NetworkManager {
    
    // Задание 1
    
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
//                print(text)
//                print(response as Any)
//                print(error?.localizedDescription as Any)
            }
            task.resume()
        }
    
    // Задание 2.1
    
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
    
    // Задание 2.2
    
    func orbitRequest(completion: @escaping (String) -> Void) {

        guard let url = URL(string: "https://swapi.dev/api/planets/1") else {
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
                let period = try JSONDecoder().decode(Planet.self, from: data)
                DispatchQueue.main.async {
                    completion(period.orbitalPeriod)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
}
