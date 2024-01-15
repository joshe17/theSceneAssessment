//
//  DogBreedBasic.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/12/24.
//

import Foundation

struct DogBreedBasic: Identifiable, Decodable, Hashable {
    static func == (lhs: DogBreedBasic, rhs: DogBreedBasic) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let origin: String?
    let image: DogBreedImage
}
