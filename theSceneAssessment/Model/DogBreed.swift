//
//  DogBreed.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/12/24.
//

import Foundation

struct DogBreed: Identifiable, Hashable {
    static func == (lhs: DogBreed, rhs: DogBreed) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let basicInfo: DogBreedBasic
    let metaDataInfo: DogBreedMetaData
}
