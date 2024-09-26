//
//  ViewController.swift
//  PokemonApiApp
//
//  Created by Данис Гаязов on 28.7.24..
//

import UIKit

final class PokemonTableViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    
    private var pokemonList: [Results] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPokemonList()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Overrides Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        guard let pokemonDetailsVC = segue.destination as? PokemonDetailsViewController else {
            return
        }
        pokemonDetailsVC.urlPokemon = pokemonList[indexPath.row].url
    }
    
    // MARK: - Private Methods
    private func fetchPokemonList() {
        networkManager.fetchPokemonList { [weak self] result in
            switch result {
            case .success(let pokemonNames):
                DispatchQueue.main.async {
                    self?.pokemonList = pokemonNames.results
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImage(for cell: UITableViewCell, from url: URL) {
        networkManager.fetchImage(from: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        var content = cell.contentConfiguration as? UIListContentConfiguration ??
                        cell.defaultContentConfiguration()
                        content.image = image
                        cell.contentConfiguration = content
                    }
                }
            case .failure(let error):
                print("yo\(error)")
            }
        }
    }
}

// MARK: - Extensions
extension PokemonTableViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return pokemonList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonList", for: indexPath)
        let pokemon = pokemonList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = pokemon.name.capitalized
        
        let imageUrl = PokemonAPI.Endpoint.previewImage(id: pokemon.id).url
        loadImage(for: cell, from: imageUrl)
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PokemonTableViewController: UITableViewDelegate {
}
