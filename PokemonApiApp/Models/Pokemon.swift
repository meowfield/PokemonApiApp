//
//  Pokemon.swift
//  PokemonApiApp
//
//  Created by Данис Гаязов on 28.7.24..
//

import Foundation

//Будет дополняться по мере усложнения ТЗ
enum PokemonAPI {
    static let baseURL = "https://pokeapi.co/api/v2"
    static let imagePreviewURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon"
    
    enum Endpoint {
        case pokemonList
        case pokemonDescription(id: String)
        case pokemonSpecies(id: String)
        case previewImage(id: String)
        
        var url: URL {
            switch self {
            case .pokemonList:
                URL(string: "\(PokemonAPI.baseURL)/pokemon")!
            case .pokemonDescription(let id):
                URL(string: "\(PokemonAPI.baseURL)/pokemon/\(id)/")!
            case .pokemonSpecies(let id):
                URL(string: "\(PokemonAPI.baseURL)/pokemon-species/\(id)/")!
            case .previewImage(let id):
                URL(string: "\(PokemonAPI.imagePreviewURL)/\(id).png")!
            }
        }
    }
}

//https://pokeapi.co/api/v2/pokemon/
struct PokemonNames {
    let next: String?
    let previous: String?
    let results: [Results]
    
    init(json: [String: Any]) {
        self.next = json["next"] as? String
        self.previous = json["previous"] as? String
        self.results = (json["results"] as? [[String: Any]] ?? []).map { Results(json: $0) }
    }
}
struct Results {
    let id: String
    let name: String
    let url: String
    
    init(json: [String: Any]) {
        self.name = json["name"] as? String ?? ""
        self.url = json["url"] as? String ?? ""
        
        if let urlString = json["url"] as? String,
           let url = URL(string: urlString) {
            self.id = url.lastPathComponent
        } else {
            self.id = ""
        }
    }
}

//https://pokeapi.co/api/v2/pokemon/{id or name}/
struct PokemonDescription {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let abilities: [Abilities]
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? 0
        name = json["name"] as? String ?? ""
        height = json["height"] as? Int ?? 0
        weight = json["weight"] as? Int ?? 0
        
        let spritesJson = json["sprites"] as? [String: Any] ?? [:]
        sprites = Sprites(json: spritesJson)
        
        let abilitiesJson = json["abilities"] as? [[String: Any]] ?? []
        abilities = abilitiesJson.map { Abilities(json: $0) }
    }
}
struct Sprites {
    let frontDefault: String
    let other: Other
    
    init(json: [String: Any]) {
        frontDefault = json["front_default"] as? String ?? ""
        let otherJson = json["other"] as? [String: Any] ?? [:]
        other = Other(json: otherJson)
    }
}
struct Other {
    let officialArtwork: OfficialArtwork
    
    init(json: [String: Any]) {
        let officialArtworkJson = json["official-artwork"] as? [String: Any] ?? [:]
        officialArtwork = OfficialArtwork(json: officialArtworkJson)
    }
}
struct Abilities {
    let ability: Ability
    
    init(json: [String: Any]) {
        let abilityJson = json["ability"] as? [String: Any] ?? [:]
        ability = Ability(json: abilityJson)
    }
}
struct Ability {
    let name: String
    let url: String
    
    init(json: [String: Any]) {
        name = json["name"] as? String ?? ""
        url = json["url"] as? String ?? ""
    }
}
struct OfficialArtwork {
    let frontDefault: String
    
    init(json: [String: Any]) {
        frontDefault = json["front_default"] as? String ?? ""
    }
}

// https://pokeapi.co/api/v2/ability/{id}
struct PokemonAbility {
    let effectEntries: [EffectEntries]
    
    init(json: [String: Any]) {
        let effectEntriesJson = json["effect_entries"] as? [[String: Any]] ?? []
        effectEntries = effectEntriesJson.map { EffectEntries(json: $0) }
    }
}
struct EffectEntries {
    let effect: String
    let language: Language
    let shortEffect: String
    
    init(json: [String: Any]) {
        effect = json["effect"] as? String ?? ""
        let languageJson = json["language"] as? [String: Any] ?? [:]
        language = Language(json: languageJson)
        shortEffect = json["short_effect"] as? String ?? ""
    }
}
struct Language {
    let name: String
    let url: String
    
    init(json: [String: Any]) {
        name = json["name"] as? String ?? ""
        url = json["url"] as? String ?? ""
    }
}

//https://pokeapi.co/api/v2/pokemon-species/2/
struct Species {
    let evolvesFromSpecies: Results?
    
    init(json: [String: Any]) {
        if let evolvesFromJson = json["evolves_from_species"] as? [String: Any] {
            self.evolvesFromSpecies = Results(json: evolvesFromJson)
        } else {
            self.evolvesFromSpecies = nil
        }
    }
}
