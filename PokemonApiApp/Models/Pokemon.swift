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
struct PokemonDescription: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let abilities: [Abilities]
}
struct Sprites: Decodable {
    let front_default: String
    let other: Other
}
struct Abilities: Decodable {
    let ability: Ability
}
struct Ability: Decodable {
    let name: String
    let url: String
}
struct Other: Decodable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
    case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
    case frontDefault = "front_default"
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
