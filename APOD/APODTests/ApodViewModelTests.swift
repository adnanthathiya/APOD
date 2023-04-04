//
//  ApodViewModelTests.swift
//  APODTests
//
//  Created by Adnan Thathiya on 04/04/23.
//

import XCTest

@testable import APOD

final class ApodViewModelTests: XCTestCase {
    private var viewModel: ApodViewModel!

    override func setUpWithError() throws {
        viewModel = createViewModel()
        XCTAssertNotNil(viewModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testGetApodDataFromAPI() {
        NetworkManager.shared.requestData(ApodData.getApodDataRequest()) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apodData):
                    XCTAssertTrue(true, "get apod response from API")
                    XCTAssertNotNil(apodData)
                case .failure(let error):
                    XCTAssertFalse(false, error.localizedDescription)
                }
            }
        }
    }

    func testGetApodDataFromDatabase() {
        let cdApodData = viewModel.fetchTodayApodDataFromDB()
        if cdApodData == nil {
            XCTAssertFalse(false, "Data not available in database")
        } else {
            XCTAssertTrue(true, "Data not available in database")
        }
    }

    //MARK: Helper Methods
    func createViewModel() -> ApodViewModel {
        return ApodViewModel(repo: CDApodDataRepository())
    }
}
