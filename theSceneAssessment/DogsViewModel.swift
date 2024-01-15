//
//  DogsViewModel.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/12/24.
//

import Foundation
import Combine

// Helper enum to track loading states
enum AsyncStatus {
    case initial, loading, loaded, error
}

@MainActor class DogsViewModel: ObservableObject {
    // Published variables
    @Published var dogBreeds = [DogBreed]()
    @Published var status: AsyncStatus = .initial
    @Published var showErrorAlert: Bool = false
    @Published var haveReachedEnd: Bool = false
    
    //Variables
    var currentPage = 1
    var cancellables = Set<AnyCancellable>()
    let service : DogsServiceProtocol
    
    init(service: DogsServiceProtocol = DogsService()) {
        self.service = service
    }
    
    //Functions
    
    // Function to call DogsService. Stores result into dogBreeds published variable, or sets status to error
    func getDogs() {
        // if we haven't gotten the last elements to api
        if !haveReachedEnd {
            
            // check if we are already in the middle of a request
            guard status != .loading else { return }
            
            Task {
                do {
                    status = .loading
                    
                    let additionalDogsArr = try await service.fetchDogBreed(pageNumber: currentPage)
                    
                    // add new dogBreeds to current array
                    dogBreeds += additionalDogsArr
                    
                    // if we are under the limit of 10, update variable to show we have reached the end of api results
                    if additionalDogsArr.count < 10 {
                        haveReachedEnd = true
                    }
                    
                    status = .loaded
                    
                    currentPage += 1
                } catch {
                    // We only want to show the error alert if we run into an error after the first load, otherwise we will show error view.
                    if currentPage > 1 {
                        showErrorAlert = true
                    }
                    
                    status = .error
                }
            }
        }
        else {
            print("No more elements from API")
        }
    }
    
}
