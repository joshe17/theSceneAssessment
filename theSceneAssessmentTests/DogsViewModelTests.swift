//
//  DogsViewModelTests.swift
//  theSceneAssessmentTests
//
//  Created by Joshua Ho on 1/14/24.
//

import XCTest
@testable import theSceneAssessment
import Combine

final class DogsViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = Set<AnyCancellable>()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Test to ensure that getDogs() successfully calls api and populates dogBreeds published variable
    func test_getDogs_success() async throws {
        let viewModel = await DogsViewModel(service: MockDogsService(basic: .getDogBreedsBasicSuccess, meta: .getDogBreedsMetaSuccess))

        let exp = XCTestExpectation(description: "expecting fetch success")
        
        await viewModel.getDogs()
        
        await viewModel.$dogBreeds
            .dropFirst()
            .sink { breed in
                XCTAssertFalse(breed.isEmpty)
                XCTAssertEqual(breed.count, 1)
                let first = breed.first!
                print(first)
                XCTAssertEqual(first.basicInfo.id, 0)
                XCTAssertEqual(first.basicInfo.name, "Abyssinian")
                XCTAssertEqual(first.basicInfo.origin, "Egypt")
                XCTAssertEqual(first.basicInfo.image.id, "0XYvRd7oD")
                XCTAssertEqual(first.metaDataInfo.bredFor, "Coursing and hunting")
                XCTAssertEqual(first.metaDataInfo.lifeSpan, "10 to 13 years")
                XCTAssertEqual(first.metaDataInfo.breedGroup, "Hound")
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that getDogs() fails and changed status published variable to error when finding error in basic fetch
    func test_getDogs_badBasicData_failure() async throws {
        let viewModel = await DogsViewModel(service: MockDogsService(basic: .getDogBreedsBasicFailure, meta: .getDogBreedsMetaSuccess))

        let exp = XCTestExpectation(description: "expecting fetch success")
        
        await viewModel.getDogs()
        
        await viewModel.$status
            .dropFirst()
            .sink { s in
                print(s)
                XCTAssert(s == .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that getDogs() fails and changed status published variable to error when finding error in metaData fetch
    func test_getDogs_badMetaData_failure() async throws {
        let viewModel = await DogsViewModel(service: MockDogsService(basic: .getDogBreedsBasicSuccess, meta: .getDogBreedsMetaFailure))

        let exp = XCTestExpectation(description: "expecting getDogs failure because of metaData")
        
        await viewModel.getDogs()
        
        await viewModel.$status
            .dropFirst()
            .sink { s in
                print(s)
                XCTAssert(s == .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }

    // Test to ensure that getDogs() fails and changed status published variable to error when finding error in both fetches
    func test_getDogs_badBothData_failure() async throws {
        let viewModel = await DogsViewModel(service: MockDogsService(basic: .getDogBreedsBasicFailure, meta: .getDogBreedsMetaFailure))

        let exp = XCTestExpectation(description: "expecting getDogs failure because of basicData")
        
        await viewModel.getDogs()
        
        await viewModel.$status
            .dropFirst()
            .sink { s in
                XCTAssert(s == .error)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    // Test to ensure that when getDogs() reaches the end of API results, haveReachedEnd published variable is updataed
    func test_haveReachedEnd_success() async throws {
        let viewModel = await DogsViewModel(service: MockDogsService(basic: .getDogBreedsBasicSuccess, meta: .getDogBreedsMetaSuccess))

        let exp = XCTestExpectation(description: "expecting haveReachedEnd success")
        
        await viewModel.getDogs()
        
        await viewModel.$haveReachedEnd
            .dropFirst()
            .sink { s in
                XCTAssert(s == true)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [exp], timeout: 10)
    }
}


enum FileName: String {
    case getDogBreedsBasicSuccess, getDogBreedsBasicFailure, getDogBreedsMetaSuccess, getDogBreedsMetaFailure
}

// Mock service for testing. Allows us to test results from bundle without having to make unnecessary calls to the network
class MockDogsService: DogsServiceProtocol {
    let basicFileName: FileName
    let metaFileName: FileName
    
    init(basic: FileName, meta: FileName) {
        self.basicFileName = basic
        self.metaFileName = meta
    }
    
    func loadMockData(file: String) -> URL? {
        return Bundle(for: type(of: self)).url(forResource: file, withExtension: "json")
    }
    
    func fetchDogBreed(pageNumber: Int) async throws -> [theSceneAssessment.DogBreed] {

        do {
            var dogBreedArr = [DogBreed]()

            let basicArray = try await fetchDogBreedBasic(pageNumber: pageNumber)
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
    
    func fetchDogBreedBasic(pageNumber: Int) async throws -> [theSceneAssessment.DogBreedBasic] {
        guard let url = loadMockData(file: basicFileName.rawValue) else { throw APIError.invalidUrl }
        
        let data = try! Data(contentsOf: url)
        
        do {
            return try JSONDecoder().decode([theSceneAssessment.DogBreedBasic].self, from: data)
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
    
    func fetchDogBreedMetaData(breedId: Int) async throws -> theSceneAssessment.DogBreedMetaData {
        guard let url = loadMockData(file: metaFileName.rawValue) else { throw APIError.invalidUrl }
        
        let data = try! Data(contentsOf: url)
        
        do {
            return try JSONDecoder().decode(theSceneAssessment.DogBreedMetaData.self, from: data)
        } catch {
            print(error)
            throw APIError.decodingError
        }
    }
}
