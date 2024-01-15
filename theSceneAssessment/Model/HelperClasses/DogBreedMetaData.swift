//
//  DogBreedMetaData.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/12/24.
//

import Foundation

struct DogBreedMetaData: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let lifeSpan: String
    let bredFor: String?
    let breedGroup: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case lifeSpan = "life_span"
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
    }
}
