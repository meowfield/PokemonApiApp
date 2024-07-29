//
//  ViewController.swift
//  PokemonApiApp
//
//  Created by Данис Гаязов on 28.7.24..
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPokemonList()
    }

    private func fetchPokemonList() {
        let link = Link()
        URLSession.shared.dataTask(with: link.pokemonList()) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let pokemonList = try JSONDecoder().decode(PokemonNames.self, from: data)
                print(pokemonList)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

