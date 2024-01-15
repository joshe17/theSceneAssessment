//
//  DogsService.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/12/24.
//

import Foundation
import Combine

// Protocol for DogsSerice to allow for mock service testing
protocol DogsServiceProtocol {
    func fetchDogBreed(pageNumber: Int) async throws -> [DogBreed]
    func fetchDogBreedBasic(pageNumber: Int) async throws -> [DogBreedBasic]
    func fetchDogBreedMetaData(breedId: Int) async throws -> DogBreedMetaData
}

// Network class for api calls to the dog api
class DogsService: DogsServiceProtocol {
    let baseUrl = "https://api.thedogapi.com/v1"
    let apiKey = "live_Fn0umZDYk61JaMcQciZAZ4kxr8scQ4bVzBAtmea89vc2NeJkyJn3ttSeNfGWRA3A"
    
    // Function that makes nested api calls and return array of type [DogBreed]
    func fetchDogBreed(pageNumber: Int) async throws -> [DogBreed] {
        do {
            var dogBreedArr = [DogBreed]()
            
            //Make array of basic information
            let basicArray = try await fetchDogBreedBasic(pageNumber: pageNumber)
            
            //Get detailed information for each breed based on id
            for breed in basicArray {
                let md = try await fetchDogBreedMetaData(breedId: breed.id)
                dogBreedArr.append(DogBreed(basicInfo: breed, metaDataInfo: md))
            }
            
            return dogBreedArr

        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
    
    // FUnction that fetches basic information for dog breeds. Returns an array of type [DogBreedBasic]. Limits results to 10 per call, paginated
    func fetchDogBreedBasic(pageNumber: Int) async throws -> [DogBreedBasic] {
        let urlString = baseUrl + "/breeds?api_key=\(apiKey)&limit=10&page=\(pageNumber)"
  
        guard let url = URL(string: urlString) else { throw APIError.invalidUrl }
       
        let (data, response) = try await URLSession.shared.data(from: url)
       
        let resp = response as? HTTPURLResponse

        if resp?.statusCode != 200 {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode([DogBreedBasic].self, from: data)
    }
    
    // Function that fetches metadata for dog breeds. Returns an object of type DogBreedMetaData. Takes in a breedId argument and returns data for given id
    func fetchDogBreedMetaData(breedId: Int) async throws -> DogBreedMetaData {
        let urlString = baseUrl + "/breeds/\(breedId)"

        guard let url = URL(string: urlString) else { throw APIError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let resp = response as? HTTPURLResponse

        if resp?.statusCode != 200 {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(DogBreedMetaData.self, from: data)
    }
}
