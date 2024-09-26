//
//  NetworkManager.swift
//  PokemonApiApp
//
//  Created by Данис Гаязов on 31.7.24..
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError
}

final class NetworkManager {

    // MARK: - Class Properties
    static let shared = NetworkManager()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetch<T: Decodable>(
        _ type: T.Type,
        from url: URL,
        completion: @escaping(Result<T, NetworkError>) -> Void
    ) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print(error ?? "No error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                let dataModel = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(
        from url: URL,
        completion: @escaping(Result<Data, NetworkError>) -> Void
    ) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
}

