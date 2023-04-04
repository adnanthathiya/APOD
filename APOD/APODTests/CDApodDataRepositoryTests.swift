//
//  CDApodDataRepositoryTests.swift
//  APODTests
//
//  Created by Adnan Thathiya on 04/04/23.
//

import XCTest

@testable import APOD

final class CDApodDataRepositoryTests: XCTestCase {
    var repo: CDApodDataRepository!

    override func setUpWithError() throws {
        repo = createRepo()
        XCTAssertNotNil(repo)
    }

    override func tearDownWithError() throws {
        repo = nil
    }

    func testIsDataAvailable() {
        let isDataAvailable = repo.isDataAvailable(for: getTodayDate())

        if isDataAvailable {
            XCTAssertTrue(true,"Data available in DB for \(getTodayDate())")
        } else {
            XCTAssertFalse(false,"Data not available in DB for \(getTodayDate())")
        }
    }

    func testSaveApodDataToDB() {
        let apodData = createApodDataModel()
        XCTAssertEqual(repo.save(with: apodData), true)

    }

    func testGetCDApodDataFromDB() {
        let cdApodData = repo.getCDApodData(by: getTodayDate())

        XCTAssertNotNil(cdApodData)

        XCTAssertEqual(cdApodData?.title, "Olympus Mons: Largest Volcano in the Solar System")
        XCTAssertEqual(cdApodData?.explanation, "The largest volcano in our Solar System is on Mars.  Although three times higher than Earth's Mount Everest, Olympus Mons will not be difficult for humans to climb because of the volcano's shallow slopes and Mars' low gravity.  Covering an area greater than the entire Hawaiian volcano chain, the slopes of Olympus Mons typically rise only a few degrees at a time.  Olympus Mons is an immense shield volcano, built long ago by fluid lava.  A relatively static surface crust allowed it to build up over time. Its last eruption is thought to have been about 25 million years ago.  The featured image was taken by the European Space Agency's robotic Mars Express spacecraft currently orbiting the  Red Planet.    Your Sky Surprise: What picture did APOD feature on your birthday? (post 1995)")
        XCTAssertEqual(cdApodData?.mediaType, "image")
        XCTAssertEqual(cdApodData?.date, getTodayDate())
    }

    func testUpdateApodDataToDB() {
        let apodData = createApodDataModel()
        XCTAssertEqual(repo.update(with: apodData), true)
    }


    //MARK: Helper Methods
    func createRepo() -> CDApodDataRepository {
        return CDApodDataRepository()
    }

    func createApodDataModel() -> ApodData {
        return .init(title: "Olympus Mons: Largest Volcano in the Solar System",
                     explanation: "The largest volcano in our Solar System is on Mars.  Although three times higher than Earth's Mount Everest, Olympus Mons will not be difficult for humans to climb because of the volcano's shallow slopes and Mars' low gravity.  Covering an area greater than the entire Hawaiian volcano chain, the slopes of Olympus Mons typically rise only a few degrees at a time.  Olympus Mons is an immense shield volcano, built long ago by fluid lava.  A relatively static surface crust allowed it to build up over time. Its last eruption is thought to have been about 25 million years ago.  The featured image was taken by the European Space Agency's robotic Mars Express spacecraft currently orbiting the  Red Planet.    Your Sky Surprise: What picture did APOD feature on your birthday? (post 1995)",
                     url: "https://apod.nasa.gov/apod/image/2304/OlympusMons_MarsExpress_960.jpg",
                     mediaType: "image",
                     copyright: nil,
                     date: getTodayDate(),
                     imagePath: nil)
    }

    func getTodayDate() -> String {
        "2023-04-04"
    }
}
