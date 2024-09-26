//
//  PokemonDetailsViewController.swift
//  PokemonApiApp
//
//  Created by Данис Гаязов on 13.8.24..
//
import UIKit

final class PokemonDetailsViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var abilities: UILabel!
    @IBOutlet weak var evolvesFromSpecies: UILabel!
    
    // MARK: - Public Properties
    var urlPokemon = ""
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    
    lazy var id = String(urlPokemon.split(separator: "/")[5])
        
    private var pokemon: PokemonDescription?
    private var pokemonSpecies: Species?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        fetchPokemon()
    }
    
    // MARK: - Private Methods
    private func updateUI() {
            guard let pokemon = pokemon else { return }
            
            name.text = "Name: \(pokemon.name.capitalized)"
            height.text = "Height: \(pokemon.height)"
            weight.text = "Weight: \(pokemon.weight)"
            abilities.text = "Abilities: \(pokemon.abilities.map { $0.ability.name }.joined(separator: ", "))"
            evolvesFromSpecies.text = "Evolves from: \(pokemonSpecies?.evolvesFromSpecies?.name.capitalized ?? "First Pokemon from evolution")"
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        
        private func setupInitialState() {
            activityIndicator.startAnimating()
            [name, height, weight, abilities, evolvesFromSpecies].forEach { $0?.text = "" }
            imageView.image = nil
        }
        
    private func fetchPokemon() {
            networkManager.fetchPokemon(id: id) { [weak self] result in
                switch result {
                case .success(let pokemon):
                    self?.pokemon = pokemon
                    self?.fetchPokemonSpecies()
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.isHidden = true
                    }
                }
            }
        }
    
    private func fetchPokemonSpecies() {
            networkManager.fetchPokemonSpecies(id: id) { [weak self] result in
                switch result {
                case .success(let species):
                    self?.pokemonSpecies = species
                    DispatchQueue.main.async {
                        self?.updateUI()
                        self?.fetchImage()
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.isHidden = true
                    }
                }
            }
        }
    
    private func fetchImage() {
            guard let imageUrlString = pokemon?.sprites.other.officialArtwork.frontDefault,
                  let imageUrl = URL(string: imageUrlString) else {
                print(NetworkError.invalidUrl)
                return
            }
            
            networkManager.fetchImage(from: imageUrl) { [weak self] result in
                switch result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: imageData)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
}
