//
//  Pokemon.swift
//  PokemonApiApp
//
//  Created by Данис Гаязов on 28.7.24..
//

import Foundation

//https://pokeapi.co/api/v2/pokemon/
struct PokemonNames: Decodable {
    let next: String?
    let previous: String?
    let results: [Results]
}

struct Results: Decodable {
    let name: String
    let url: String
}

//Будет дополняться по мере усложнения ТЗ
struct Link {
    private let baseUrl = "https://pokeapi.co/api/v2"
    private let imagePreview = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon"
    func pokemonList() -> URL {
        return URL(string:"\(baseUrl)/pokemon")!        
    }
    func pokemonDescription(id: String) -> URL {
            return URL(string:"\(baseUrl)/pokemon/\(id)/")!
    }
    func pokemonSpecies(id: String) -> URL {
            return URL(string:"\(baseUrl)/pokemon-species/\(id)/")!
    }
    
    func getPreviewImage(id: String) -> URL? {
        return URL(string: "\(imagePreview)/\(id).png")
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
struct PokemonAbility: Decodable {
    let effect_entries: [EffectEntries]
}
struct EffectEntries: Decodable {
    let effect: String
    let language: [Language]
    let short_effect: String
}
struct Language: Decodable {
    let name: String
    let url: String
}

//https://pokeapi.co/api/v2/pokemon-species/2/
struct Species: Decodable {
    let evolvesFromSpecies: Results?
    
    enum CodingKeys: String, CodingKey {
        case evolvesFromSpecies = "evolves_from_species"
    }
}
