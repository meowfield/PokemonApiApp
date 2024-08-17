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
    private let link = Link()
    
    lazy var id = String(urlPokemon.split(separator: "/")[5])
        
    private var pokemon: PokemonDescription?
    private var pokemonSpecies: Species?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        fetchAllData()
        activityIndicator.startAnimating()
    }
    
    // MARK: - Private Methods
    private func updateUI() {
        DispatchQueue.main.async {
            self.name.text = "Name: \(self.pokemon?.name.capitalized ?? "N/A")"
            self.height.text = "Height: \(self.pokemon?.height ?? 0)"
            self.weight.text = "Weight: \(self.pokemon?.weight ?? 0)"
            self.abilities.text = """
            Abilities: \
            \(self.pokemon?.abilities.map { $0.ability.name }.joined(separator: ", ") ?? "")
            """
            self.evolvesFromSpecies.text = """
            Evolves from: \(self.pokemonSpecies?.evolvesFromSpecies?.name.capitalized ??
            "First Pokemon from evolution")
            """
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    private func setupInitialState() {
            activityIndicator.startAnimating()
            [name, height, weight, abilities, evolvesFromSpecies].forEach { $0?.text = "" }
            imageView.image = nil
        }
    
    private func fetchAllData() {
        fetchPokemon { [weak self] in
            self?.fetchPokemonSpecies {
                self?.updateUI()
            }
        }
    }
        
    private func fetchPokemon(completion: @escaping () -> Void) {
        networkManager.fetch(
            PokemonDescription.self,
            from: link.pokemonDescription(id: id)
        ) { [weak self] result in
            switch result {
            case .success(let PokemonDescription):
                DispatchQueue.main.async { [unowned self] in
                    self?.pokemon = PokemonDescription
                    self?.fetchImage()
                    completion()
                }
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    private func fetchPokemonSpecies(completion: @escaping () -> Void) {
        networkManager.fetch(Species.self, from: link.pokemonSpecies(id: id)) { [weak self] result in
            switch result {
            case .success(let species):
                self?.pokemonSpecies = species
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    private func fetchImage() {
        guard let imageUrlString = pokemon?.sprites.other.officialArtwork.frontDefault,
              let imageUrl = URL(string: imageUrlString) else {
            print(NetworkError.invalidUrl)
            return
        }
        networkManager.fetchImage(from: imageUrl) { [unowned self] result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
