//
//  ApiService.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 29/12/2020.
//

import Foundation

class ApiService {
    
    static let shared = ApiService()
    private init() {}
    
    private let baseUrl = "https://api.themoviedb.org/3/movie"
    private let apiKey = "97085397ac3d7d66a85e2f4db8d9225d"
    
    func fetchData<T>(
        route: String,
        value: T.Type,
        com: @escaping (Result<T, Error>)-> Void
    ) where T: Decodable {
        
        var urlComponents = URLComponents(string: baseUrl + route)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        urlComponents?.queryItems = queryItems
        let urlRequest = URLRequest(url: URL(string: urlComponents!.string!)!)
        
        let task = URLSession(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                com(.failure(error))
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    com(.success(result))
                } catch let reqError{
                    com(.failure(reqError))
                }
            }
        }
        
        task.resume()
    }
    
}
