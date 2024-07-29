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
    let baseUrl = "https://pokeapi.co/api/v2/"
    
    func pokemonList() -> URL {
        return URL(string:"\(baseUrl)/pokemon")!
    }
}

//https://pokeapi.co/api/v2/pokemon/{id or name}/
struct PokemonDescription: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let abiltiess: Abilities
}
struct Sprites: Decodable {
    let front_default: String
}
struct Abilities: Decodable {
    let ability: Ability
}
struct Ability: Decodable {
    let name: String
    let url: String
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

