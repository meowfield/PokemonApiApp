//
//  ViewController.swift
//  PokemonApiApp
//
//  Created by Данис Гаязов on 28.7.24..
//

import UIKit


final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var pokemonList: [Results] = []
    private let networkManager = NetworkManager.shared
    private let link = Link()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCourses()
        tableView.dataSource = self
        tableView.delegate = self
        print(pokemonList)
    }

    private func fetchCourses() {
        networkManager.fetch(PokemonNames.self, from: link.pokemonList()) { result in
            switch result {
            case .success(let pokemonNames):
                DispatchQueue.main.async {
                    self.pokemonList = pokemonNames.results
                    self.tableView.reloadData()
                    print("Загружено покемонов: \(self.pokemonList.count)")
                    print(self.pokemonList)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonList")! // временная лажа, поменять
        let pokemon = pokemonList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = pokemon.name.capitalized
        let id = pokemon.url.split(separator: "/")[5]
        if let imageUrl = URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"){
            loadImage(for: cell, from: imageUrl)
        }
        cell.contentConfiguration = content
        return cell
    }
    
    
    private func loadImage(for cell: UITableViewCell, from url: URL) {
        networkManager.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        var content = cell.contentConfiguration as? UIListContentConfiguration ?? cell.defaultContentConfiguration()
                        content.image = image
                        cell.contentConfiguration = content
                    }
                }
            case .failure(let error):
                print("yo\(error)")
            }
        }
    }
    
//    private func fetchPokemonList() {
//        let link = Link()
//        URLSession.shared.dataTask(with: link.pokemonList()) { data, _, error in
//            guard let data else {
//                print(error?.localizedDescription ?? "No error description")
//                return
//            }
//            do {
//                let pokemonList = try JSONDecoder().decode(PokemonNames.self, from: data)
//                print(pokemonList)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }


    
}

