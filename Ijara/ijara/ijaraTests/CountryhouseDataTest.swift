//
//  CountryhouseDataTest.swift
//  ijaraTests
//
//  Created by Sarvar Qosimov on 30/11/23.
//

import XCTest
@testable import ijara
    
final class CountryhouseDataTest: XCTestCase {
    
    override func setUp() {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testAPI(){
        let expectation = XCTestExpectation(description: "expectForNetwork")
        
        API.getAllHouses { houses in
            
            guard let houses = houses else { return }
            
            for house in houses {
                XCTAssertNotNil(house)
            }
            
            XCTAssertEqual(houses.count, 27)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 7)
    }
    
    func testSortingLogic(){
       let result = SortingPrices.sortByExpensive([
            (100000, 1),
            (150000, 2),
            (75000 , 3),
            (200000, 4),
            (50000 , 5)
        ])
        
        XCTAssertEqual(result, [4, 2, 1, 3, 5])
    }
    
    func testLikedProducts(){
        let likedProducts = LikedProducts()
        
        XCTAssertEqual(
            likedProducts.isLiked(sevriceType: .house, id: 1),
            !likedProducts.isLikedPerform(sevriceType: .house, id: 1)
        )
    }
    
    func some(){
        
    }
    
}
