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
    case parsingError
}

final class NetworkManager {
    
    // MARK: - Class Properties
    static let shared = NetworkManager()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchPokemon(id: String, completion: @escaping (Result<PokemonDescription, NetworkError>) -> Void) {
            let url = PokemonAPI.Endpoint.pokemonDescription(id: id).url
            
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        completion(.failure(.parsingError))
                        return
                    }
                    
                    let pokemon = PokemonDescription(json: json)
                    completion(.success(pokemon))
                    
                case .failure(_):
                    completion(.failure(.noData))
                }
            }
        }
    
    func fetchPokemonSpecies(id: String, completion: @escaping (Result<Species, NetworkError>) -> Void) {
            let url = PokemonAPI.Endpoint.pokemonSpecies(id: id).url
            
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        completion(.failure(.parsingError))
                        return
                    }
                    
                    let species = Species(json: json)
                    completion(.success(species))
                    
                case .failure(_):
                    completion(.failure(.noData))
                }
            }
        }
        
        func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    completion(.failure(.noData))
                }
            }
        }
        
        func fetchPokemonList(completion: @escaping (Result<PokemonNames, NetworkError>) -> Void) {
            let url = PokemonAPI.Endpoint.pokemonList.url
            
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        completion(.failure(.parsingError))
                        return
                    }
                    
                    let pokemonNames = PokemonNames(json: json)
                    completion(.success(pokemonNames))
                    
                case .failure(_):
                    completion(.failure(.noData))
                }
            }
        }
}

